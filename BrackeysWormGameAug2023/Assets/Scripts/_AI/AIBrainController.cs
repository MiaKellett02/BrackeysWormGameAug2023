////////////////////////////////////////////////////////////////////////////////////////////
/// Filename AIBrainController.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To control the behaviour of AIs, to make them wander, aggro and attack.
////////////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIBrainController : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[Header("General AI State Variables")]
	[SerializeField] private EntityFactionIdentifier m_thisAiFactionIdentifier;
	[SerializeField] private MonoBehaviour m_movementScript;
	[SerializeField] private Transform m_AiHeadTransform;
	[Header("Wander State Variables.")]
	[Header("Aggro State Variables.")]
	[SerializeField] private AIAggroTrigger m_aiAggroTrigger;
	[Header("Attack State Variables.")]
	[SerializeField] private bool m_useAttackState = false;
	[SerializeField] private AIAttackTrigger m_aiAttackTrigger;
	[SerializeField] private Transform m_attackPrefab;

	//Private Variables.
	private ICanMove m_canMove = null;
	private bool isAggroed = false;
	private bool isAttacking = false;

	//AI States.
	private WanderState m_wanderState;
	private AggroState m_aggroState;
	private AttackState m_attackState;
	private IAIState m_currentState;

	//Public Functions.

	//Unity Functions.
	private void Start() {
		SetupMovementScript();
		m_wanderState = new WanderState(m_canMove, m_AiHeadTransform, 5.0f, this.transform.position + Vector3.one * 5.0f);
		m_aggroState = new AggroState(m_canMove, m_AiHeadTransform);
		m_attackState = new AttackState();
		SwitchState(m_wanderState);

		//Subscribe to all the trigger events.
		m_aiAggroTrigger.OnAiAggro += AiAggroTrigger_OnAiAggro;
		m_aiAggroTrigger.OnAiStopAggro += AiAggroTrigger_OnAiStopAggro;
		if (m_useAttackState) {
			m_aiAttackTrigger.OnAiAttackTriggered += AiAttackTrigger_OnAiAttackTriggered;
			m_aiAttackTrigger.OnAiAttackStopped += AiAttackTrigger_OnAiAttackStopped;
		}
	}

	private void Update() {
		if (m_currentState != null) {
			m_currentState.StateUpdate();
		}
	}

	private void FixedUpdate() {
		if (m_currentState != null) {
			m_currentState.StateFixedUpdate();
		}
	}

	//Private Functions.

	private void SwitchState(IAIState a_newState) {
		if (m_currentState != null) {
			m_currentState.ExitState();
		}
		m_currentState = a_newState;
		m_currentState.EnterState();
	}

	//Event Listeners.

	private void AiAggroTrigger_OnAiStopAggro(object sender, AIAggroTrigger.OnAiAggroEventArgs e) {
		SwitchState(m_wanderState);
		isAggroed = false;
		//Debug.Log("AI " + this.gameObject.name + " will no longer aggro.");
	}

	private void AiAggroTrigger_OnAiAggro(object sender, AIAggroTrigger.OnAiAggroEventArgs e) {
		//Check if it's a valid enemy.
		if (e.factionOfCreature != m_thisAiFactionIdentifier.GetEntityFaction() && !isAggroed) {
			//It's a valid enemy so switch to aggro state.
			isAggroed = true;
			m_aggroState.SetTargetTransform(e.creatureThatCausedAggro);
			SwitchState(m_aggroState);
			Debug.Log("AI was aggroed by " + e.factionOfCreature.ToString() + " " + e.creatureThatCausedAggro.gameObject.name);
		}
	}


	private void AiAttackTrigger_OnAiAttackStopped(object sender, AIAttackTrigger.OnAiAttackTriggeredEventArgs e) {
		SwitchState(m_aggroState);
		isAttacking = false;
	}

	private void AiAttackTrigger_OnAiAttackTriggered(object sender, AIAttackTrigger.OnAiAttackTriggeredEventArgs e) {
		//Check if it's a valid enemy.
		if (e.factionOfCreature != m_thisAiFactionIdentifier.GetEntityFaction() && !isAttacking) {
			//It's a valid enemy so switch to aggro state.
			isAttacking = true;
			m_aggroState.SetTargetTransform(e.creatureThatTriggeredAttack);
			SwitchState(m_aggroState);
			Debug.Log("AI is going to attack " + e.factionOfCreature.ToString() + " " + e.creatureThatTriggeredAttack.gameObject.name);
		}
	}

	//Utility.
	private void SetupMovementScript() {
		if (m_movementScript != null && m_movementScript.gameObject.TryGetComponent(out ICanMove canMoveComponent)) {
			m_canMove = canMoveComponent;
		} else if (m_movementScript != null && m_canMove == null) {
			Debug.LogError("Attached Script does not inherit from ICanMove, please attach a valid movement script");
		}
	}
}

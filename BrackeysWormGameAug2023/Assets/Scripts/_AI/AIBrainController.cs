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

	//Private Variables.
	private ICanMove m_canMove = null;
	private bool isAggroed = false;

	//AI States.
	private WanderState m_wanderState;
	private AggroState m_aggroState;
	private IAIState m_currentState;

	//Public Functions.

	//Unity Functions.
	private void Start() {
		SetupMovementScript();
		m_wanderState = new WanderState(m_canMove, m_AiHeadTransform, 5.0f, this.transform.position + Vector3.one * 5.0f);
		m_aggroState = new AggroState(m_canMove, m_AiHeadTransform);
		SwitchState(m_wanderState);

		//Subscribe to all the trigger events.
		m_aiAggroTrigger.OnAiAggro += AiAggroTrigger_OnAiAggro;
		m_aiAggroTrigger.OnAiStopAggro += AiAggroTrigger_OnAiStopAggro;
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
	private void ValidateState() {

	}

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

	//Utility.
	private void SetupMovementScript() {
		if (m_movementScript != null && m_movementScript.gameObject.TryGetComponent(out ICanMove canMoveComponent)) {
			m_canMove = canMoveComponent;
		} else if (m_movementScript != null && m_canMove == null) {
			Debug.LogError("Attached Script does not inherit from ICanMove, please attach a valid movement script");
		}
	}
}

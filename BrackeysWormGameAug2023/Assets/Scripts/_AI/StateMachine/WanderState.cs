//////////////////////////////////////////////////////////////////////////////
/// Filename: WanderState.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To make an AI Wander around aimlessly.
//////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WanderState : IAIState {
	//Private Variables.
	//Movement Script.
	private ICanMove m_movementScript;
	private Transform m_AITransform;

	//Target Variables.
	private float m_timeBetweenSwitchingTargets;
	private float m_switchingTargetsTimer;
	private Vector3 m_targetPostion;

	//Constructor.
	public WanderState(ICanMove a_movementScript, Transform a_AiTransform, float a_timeBetweenSwitchingTargets, Vector3 a_firstPosition) {
		//Movement script.
		m_movementScript = a_movementScript;
		m_AITransform = a_AiTransform;

		//Set up target variables.
		m_timeBetweenSwitchingTargets = a_timeBetweenSwitchingTargets;
		m_switchingTargetsTimer = 0;
		m_targetPostion = a_firstPosition;
	}

	//Public Functions.
	public void EnterState() {
		m_switchingTargetsTimer = m_timeBetweenSwitchingTargets;//Set timer to max.
	}

	public void ExitState() {

	}

	public void StateUpdate() {
		HandleTargetting();
		HandleRotation();
		HandleMovement();
	}

	public void StateFixedUpdate() {

	}

	//Private Functions.
	//Movement functions.
	private void HandleMovement() {
		m_movementScript.MoveForward();
	}

	private void HandleRotation() {
		//Compare direction the ai is facing to the direction of the target.
		Vector3 directionToTarget = (m_targetPostion - m_AITransform.position).normalized;
		float directionSimilarity = Vector3.Dot(m_AITransform.up, directionToTarget);
		if(directionSimilarity >= 0.95) {
			//Is similar enough so we don't need to rotate anymore.
			return;
		}

		//Need to rotate some more.
		//Find whether we need to rotate left or right.
		float rightVectorSimilarity = Vector3.Dot(m_AITransform.right, directionToTarget);
		if(rightVectorSimilarity > 0) {
			//We need to rotate right.
			m_movementScript.TurnRight();
		} else {
			//We need to rotate left.
			m_movementScript.TurnLeft();
		}
	}

	//Targetting functions.
	private void HandleTargetting() {
		if (m_switchingTargetsTimer <= 0) {
			//Reset timer.
			m_switchingTargetsTimer = m_timeBetweenSwitchingTargets;

			//Update the target position.
			m_targetPostion = GetRandomPositionAroundOldPosition(10.0f);
		} else {
			m_switchingTargetsTimer -= Time.deltaTime;
		}
	}

	//Utility Functions.
	private Vector3 GetRandomPositionAroundOldPosition(float a_maxDistance) {
		//Get the player position.
		Vector3 oldTargetPos = m_targetPostion;

		//Get a random position around the player and return it.
		Vector2 randomDirVec2 = new Vector2(UnityEngine.Random.Range(-100.0f, 100.0f), UnityEngine.Random.Range(-100.0f, 100.0f));
		randomDirVec2.Normalize();
		Vector3 randomDir = new Vector3(randomDirVec2.x, randomDirVec2.y, 0.0f);

		//Get a random multiplier with the min distance being 1 and the max distance being the radius passed in.
		float randomMultiplier = Random.Range(1.0f, a_maxDistance);
		return (m_targetPostion + randomDir) * randomMultiplier;
	}
}

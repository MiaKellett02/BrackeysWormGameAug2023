///////////////////////////////////////////////////////////////////////////////////////
/// Filename: AggroState.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To handle the logic for when an AI is aggroed.
///////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AggroState : IAIState {
	//Private Variables.
	//Movement Script.
	private ICanMove m_movementScript;
	private Transform m_AITransform;

	//Target Variables.
	private Transform m_targetTransform;

	//Constructor.
	public AggroState(ICanMove a_movementScript, Transform a_AiTransform) {
		//Movement script.
		m_movementScript = a_movementScript;
		m_AITransform = a_AiTransform;

		//Set up target variables.
		m_targetTransform = null;
	}

	//Public Functions.
	public void EnterState() {

	}

	public void ExitState() {
		//Set the target transform to null.
		SetTargetTransform(null);
	}

	public void StateUpdate() {
		if (m_targetTransform != null) {
			HandleRotation();
			HandleMovement();
		}
	}

	public void StateFixedUpdate() {

	}

	public void SetTargetTransform(Transform a_targetTransform) {
		m_targetTransform = a_targetTransform;
	}

	//Private Functions.
	//Movement functions.
	private void HandleMovement() {
		m_movementScript.MoveForward();
	}

	private void HandleRotation() {
		//Compare direction the ai is facing to the direction of the target.
		Vector3 directionToTarget = (m_targetTransform.position - m_AITransform.position).normalized;
		float directionSimilarity = Vector3.Dot(m_AITransform.up, directionToTarget);
		if (directionSimilarity >= 0.95) {
			//Is similar enough so we don't need to rotate anymore.
			return;
		}

		//Need to rotate some more.
		//Find whether we need to rotate left or right.
		float rightVectorSimilarity = Vector3.Dot(m_AITransform.right, directionToTarget);
		if (rightVectorSimilarity > 0) {
			//We need to rotate right.
			m_movementScript.TurnRight();
		} else {
			//We need to rotate left.
			m_movementScript.TurnLeft();
		}
	}
}

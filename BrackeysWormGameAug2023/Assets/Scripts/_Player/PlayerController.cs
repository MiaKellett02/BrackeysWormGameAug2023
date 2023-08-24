///////////////////////////////////////////////////////////////////////////////////
/// Filename: PlayerController.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: To allow the player to control an entity.
///////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private MonoBehaviour m_movementScript;

	//Variables.
	private ICanMove m_canMove = null;

	//Unity Functions.
	private void Awake() {
		SetupMovementScript();
	}

	private void Start() {
		PlayerInput.Instance.WKeyHeldDown += PlayerInput_WKeyHeldDown;
		PlayerInput.Instance.AKeyHeldDown += PlayerInput_AKeyHeldDown;
		PlayerInput.Instance.DKeyHeldDown += PlayerInput_DKeyHeldDown;
	}

	private void OnValidate() {
		SetupMovementScript();
	}

	//Private Functions.
	private void PlayerInput_DKeyHeldDown(object sender, System.EventArgs e) {
		m_canMove.TurnRight();
	}

	private void PlayerInput_AKeyHeldDown(object sender, System.EventArgs e) {
		m_canMove.TurnLeft();
	}

	private void PlayerInput_WKeyHeldDown(object sender, System.EventArgs e) {
		m_canMove.MoveForward();
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

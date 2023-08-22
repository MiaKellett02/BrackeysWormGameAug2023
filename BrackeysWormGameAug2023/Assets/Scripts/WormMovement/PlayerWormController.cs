using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerWormController : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private WormHeadMovementScript m_wormHeadMovementScript;

	//Unity Functions.
	private void Start() {
		PlayerInput.Instance.WKeyHeldDown += PlayerInput_WKeyHeldDown;
		PlayerInput.Instance.AKeyHeldDown += PlayerInput_AKeyHeldDown;
		PlayerInput.Instance.DKeyHeldDown += PlayerInput_DKeyHeldDown;
	}

	//Private Functions.
	private void PlayerInput_DKeyHeldDown(object sender, System.EventArgs e) {
		m_wormHeadMovementScript.TurnRight();
	}

	private void PlayerInput_AKeyHeldDown(object sender, System.EventArgs e) {
		m_wormHeadMovementScript.TurnLeft();
	}

	private void PlayerInput_WKeyHeldDown(object sender, System.EventArgs e) {
		m_wormHeadMovementScript.MoveForward();
	}
}

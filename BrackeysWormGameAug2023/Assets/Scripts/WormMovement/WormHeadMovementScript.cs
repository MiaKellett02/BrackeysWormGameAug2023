using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormHeadMovementScript : WormSegmentBase {
	//Variables To Assign via the unity inspector.
	[SerializeField][Range(0.0f, 1.0f)] private float m_movementOverTime = 0.5f;
	[SerializeField] private float m_movementSpeed = 3.5f;
	[SerializeField] private float m_rotationSensitivity = 50.0f;

	//Private Variables.
	private float m_currentRotation;

	//Unity Functions.
	protected override void Awake() {
		base.Awake();
		base.IsWormHead = true;
	}

	private void Start() {

	}

	private void FixedUpdate() {
		base.MakeChildFollowThisParent(this);
	}

	//Private Functions.
	public void TurnLeft() {
		m_currentRotation += m_rotationSensitivity * Time.deltaTime;
		Rotate();
	}

	public void TurnRight() {
		m_currentRotation -= m_rotationSensitivity * Time.deltaTime;
		Rotate();
	}

	public void MoveForward() {
		transform.position += transform.up * m_movementSpeed * Time.deltaTime;
	}

	private void Rotate() {
		transform.rotation = Quaternion.Euler(new Vector3(transform.rotation.x, transform.rotation.y, m_currentRotation));
	}

	//Utility.
	private void OnValidate() {
		WormSegmentBase.SetMovementOverTime(m_movementOverTime);
	}
}

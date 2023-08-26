using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormHeadMovementScript : WormSegmentBase, ICanMove {
	//Variables To Assign via the unity inspector.
	[SerializeField][Range(0.0f, 1.0f)] private float m_movementOverTime = 0.5f;
	[SerializeField] private float m_minDistanceFromParent = 0.5f;
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
		WormSegmentBase.SetMovementOverTime(m_movementOverTime);
		WormSegmentBase.SetMinDistanceFromParent(m_minDistanceFromParent);
	}

	private void FixedUpdate() {
		base.MakeChildFollowThisParent(this);
	}

	//Public Functions.
	public void TurnLeft() {
		m_currentRotation += m_rotationSensitivity * Time.deltaTime;
		Rotate();
	}

	public void TurnRight() {
		m_currentRotation -= m_rotationSensitivity * Time.deltaTime;
		Rotate();
	}

	public void MoveForward() {
		Vector3 pos = transform.position;
		pos += transform.up * m_movementSpeed * Time.deltaTime;
		transform.position = GameBoundaryManager.Instance.EnsurePositionIsInsideTheBounds(pos);
	}

	//Private Functions.
	private void Rotate() {
		transform.rotation = Quaternion.Euler(new Vector3(transform.rotation.x, transform.rotation.y, m_currentRotation));
	}

	//Utility.
	private void OnValidate() {
		WormSegmentBase.SetMovementOverTime(m_movementOverTime);
		WormSegmentBase.SetMinDistanceFromParent(m_minDistanceFromParent);
	}
}

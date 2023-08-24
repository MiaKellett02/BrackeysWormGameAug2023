using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AntMovementScript : MonoBehaviour, ICanMove {
	//Variables to assign via the unity inspector.
	[SerializeField] private float m_movementSpeed = 3.5f;
	[SerializeField] private float m_rotationSensitivity = 50.0f;

	//Private Variables.
	private float m_currentRotation;

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
		transform.position += transform.up * m_movementSpeed * Time.deltaTime;
	}

	//Private Functions.
	private void Rotate() {
		transform.rotation = Quaternion.Euler(new Vector3(transform.rotation.x, transform.rotation.y, m_currentRotation));
	}
}

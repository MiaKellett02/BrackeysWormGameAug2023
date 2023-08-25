///////////////////////////////////////////////////////////////////////////
/// Filename: PlayerLocationTracker.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To provide the location of the player to scripts that need it.
///////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerLocationTracker : MonoBehaviour {
	//Singleton.
	public static PlayerLocationTracker Instance { get; private set; }

	//Variables to assign via the unity inspector.
	[SerializeField] private Transform m_playerHeadTransform;

	//Public functions.
	public Vector3 GetPlayerPosition() {
		return m_playerHeadTransform.position;
	}

	//Unity Functions.
	private void Awake() {
		Instance = this;
	}
}

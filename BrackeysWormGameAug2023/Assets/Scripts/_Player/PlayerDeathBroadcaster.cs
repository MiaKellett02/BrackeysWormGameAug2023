////////////////////////////////////////////////////////////////////////////
/// Filename: PlayerDeathBroadcaster.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To broadcast when the player has specifically died.
////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDeathBroadcaster : MonoBehaviour {
	//Events.
	public static event EventHandler OnPlayerDeath;

	//Variables to assign via the unity inspector.
	[SerializeField] EntityHealth m_playerHealthScript;

	//Unity functions.
	private void Awake() {
		m_playerHealthScript.OnEntityDeath += BroadcastPlayerDeath;
	}

	//Private Functions.
	private void BroadcastPlayerDeath(object sender, EventArgs e) {
		OnPlayerDeath?.Invoke(this, EventArgs.Empty);
	}
}

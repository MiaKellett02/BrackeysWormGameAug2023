/////////////////////////////////////////////////////////////////////////////////
/// Filename: GameOverUI.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: Ui to show when the player dies and the game is over.
/////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOverUI : MonoBehaviour {
	//Unity Functions.
	private void Start() {
		PlayerDeathBroadcaster.OnPlayerDeath += PlayerDeathBroadcaster_OnPlayerDeath;//SUBSCRIBING TO THE EVENT MANUALLY HERE IS ONLY TEMPORARY.
		Hide();
	}

	//Private Functions.
	private void Show() {
		this.gameObject.SetActive(true);
	}

	private void Hide() {
		this.gameObject.SetActive(false);
	}
	private void PlayerDeathBroadcaster_OnPlayerDeath(object sender, System.EventArgs e) {
		Show();
	}

}

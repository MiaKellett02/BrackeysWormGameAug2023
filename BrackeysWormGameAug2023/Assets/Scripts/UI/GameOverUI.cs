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
		WormGameManager.Instance.OnGameOver += WormGameManager_OnGameOver;
		Hide();
	}

	//Private Functions.
	private void Show() {
		this.gameObject.SetActive(true);
	}

	private void Hide() {
		this.gameObject.SetActive(false);
	}
	private void WormGameManager_OnGameOver(object sender, System.EventArgs e) {
		Show();
	}

}

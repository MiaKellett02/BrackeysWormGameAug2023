///////////////////////////////////////////////////////////////////
/// Filename: MainMenuUI.cs
/// Author: Mia Kellett
/// Date Created: 22/08/2023
/// Brief: To control navigation to and from the main menu.
///////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class MainMenuUI : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private Button m_playButton;
	[SerializeField] private Button m_optionsButton;
	[SerializeField] private Button m_quitButton;
	[SerializeField] private TextMeshProUGUI m_versionNumberText;

	//Unity Functions.
	private void Awake() {
		m_playButton.onClick.AddListener(() => {
			Debug.Log("Play Button Pressed On Main Menu");
			Loader.Load(Loader.Scene.GameScene);
		});

		m_optionsButton.onClick.AddListener(() => {
			Debug.Log("Options Button Pressed On Main Menu");
		});

		m_quitButton.onClick.AddListener(() => {
			Debug.Log("Quit Game Button Pressed On Main Menu");
			Application.Quit();
		});

		//Get the correct version number.
		m_versionNumberText.text = "v" + Application.version;
	}
}

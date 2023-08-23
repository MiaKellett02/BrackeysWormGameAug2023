//////////////////////////////////////////////////////////////////////////////
/// Filename: PlayerInput.cs
/// Author: Mia Kellett
/// Date Created: 22/08/2023
/// Purpose: To manage all input in a central location using events.
//////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour {
	//Singleton.
	public static PlayerInput Instance {
		get; private set;
	}

	//Events.
	public event EventHandler AKeyHeldDown;
	public event EventHandler DKeyHeldDown;
	public event EventHandler WKeyHeldDown;

	//Unity Functions.
	private void Awake() {
		Instance = this;
	}

	private void Update() {
		//A key.
		if (Input.GetKey(KeyCode.A)) {
			AKeyHeldDown?.Invoke(this, EventArgs.Empty);
		}

		//D Key
		if (Input.GetKey(KeyCode.D)) {
			DKeyHeldDown?.Invoke(this, EventArgs.Empty);
		}

		//W Key
		if (Input.GetKey(KeyCode.W)) {
			WKeyHeldDown?.Invoke(this, EventArgs.Empty);
		}
	}
}

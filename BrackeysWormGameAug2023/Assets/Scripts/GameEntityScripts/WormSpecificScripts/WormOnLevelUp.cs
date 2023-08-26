/////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: WormOnLevelUp.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To trigger events required when the worm levels up.
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(EntityLevelTracker))]
public class WormOnLevelUp : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private UnityEvent OnWormLevelUp;

	//Private Variables.
	EntityLevelTracker wormLevelTracker;

	//Unity Functions.
	private void Awake() {
		wormLevelTracker = GetComponent<EntityLevelTracker>();
		wormLevelTracker.OnEntityLevelUp += WormLevelTracker_OnEntityLevelUp;
	}

	//Private functions.
	private void WormLevelTracker_OnEntityLevelUp(object sender, System.EventArgs e) {
		OnWormLevelUp?.Invoke();

		//Send a notification to the player.
		NotificationsManager.Instance.SendNotification("LEVEL UP!");
	}
}

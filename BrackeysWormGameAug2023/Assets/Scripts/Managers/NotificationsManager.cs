////////////////////////////////////////////////////////////////////////////////////
/// Filename: NotificationsManager.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To allow any script to send a notification to the player.
////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NotificationsManager : MonoBehaviour {
	//Singleton.
	public static NotificationsManager Instance { get; private set; }

	//Events.
	public class OnSendNotificationEventArgs : EventArgs {
		public string m_message;
	}
	public event EventHandler<OnSendNotificationEventArgs> OnSendNotification;

	//Variables to assign via the unity inspector.
	[SerializeField] private float m_showNextMessageCooldown = 2.0f;

	//Private Variables.
	private Queue<string> m_notificationsQueue;
	private bool m_canShowNextMessage = true;

	//Public Functions.
	public void SendNotification(string a_message) {
		m_notificationsQueue.Enqueue(a_message);
	}

	//Unity Functions.
	private void Awake() {
		Instance = this;
		m_notificationsQueue = new Queue<string>();
	}

	private void Update() {
		if(m_notificationsQueue.Count > 0 && m_canShowNextMessage) {
			//Get the message and send the event off.
			string message = m_notificationsQueue.Dequeue();
			OnSendNotificationEventArgs notificationEventArgs = new OnSendNotificationEventArgs {
				m_message = message,
			};
			OnSendNotification?.Invoke(this, notificationEventArgs);

			//Start cooldown.
			StartCoroutine(ShowNextMessageCooldown());
		}
	}

	//Private Functions.
	private IEnumerator ShowNextMessageCooldown() {
		m_canShowNextMessage = false;
		yield return new WaitForSeconds(m_showNextMessageCooldown);
		m_canShowNextMessage = true;
	}
}

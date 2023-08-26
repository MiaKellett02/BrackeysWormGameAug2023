////////////////////////////////////////////////////////////////////////////
/// Filename: NotificationsUI.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To display any notification from the notifications event.
////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class NotificationsUI : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private GameObject m_messageBox;
	[SerializeField] private TextMeshProUGUI m_messageBoxText;
	[SerializeField] private float m_timeBeforeHiding = 1.0f;

	//Unity Functions.
	private void Start() {
		NotificationsManager.Instance.OnSendNotification += NotificationsManager_OnSendNotification;
		Hide();
	}

	//Private Functions.
	private void NotificationsManager_OnSendNotification(object sender, NotificationsManager.OnSendNotificationEventArgs e) {
		ShowMessage(e.m_message);
	}

	private void ShowMessage(string a_message) {
		//Stop previous timers.
		StopAllCoroutines();

		//Reset message box.
		Hide();

		//Show Message.
		m_messageBox.gameObject.SetActive(true);
		m_messageBoxText.text = a_message;

		//Start timer to hide message after the specified timer.
		StartCoroutine(HidingTimer());
	}

	private IEnumerator HidingTimer() {
		yield return new WaitForSeconds(m_timeBeforeHiding);
		Hide();
	}

	private void Hide() {
		m_messageBox.gameObject.SetActive(false);
		m_messageBoxText.text = "";
	}
}

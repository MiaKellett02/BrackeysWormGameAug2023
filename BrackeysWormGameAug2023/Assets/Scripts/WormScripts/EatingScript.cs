//////////////////////////////////////////////////////////////////////////////////////
/// Filename: EatingScript.cs
/// Author: Mia Kellett
/// Date Created: 23/08/2023
/// Purpose: To allow an entity to eat food and gain xp.
//////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(EntityLevelTracker))]
public class EatingScript : MonoBehaviour {
	//Variables to assign via the unity inspector.

	//Private Variables.
	private EntityLevelTracker m_levelTracker;

	//Unity Functions.
	private void Start() {
		m_levelTracker = this.gameObject.GetComponent<EntityLevelTracker>();
	}

	private void OnTriggerEnter2D(Collider2D collision) {
		Debug.Log("Collision!!!");
		if(collision.TryGetComponent(out IXPDropper xpDropper)) {
			m_levelTracker.GiveXPToEntityFromXPDropper(xpDropper);
			Destroy(collision.gameObject);//Cleanup.
		}
	}
}

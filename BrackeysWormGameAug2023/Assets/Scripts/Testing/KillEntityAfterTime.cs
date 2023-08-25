/////////////////////////////////////////////////////////////////////////
/// Filename: KillEntityAfterTime.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To test killing entities in the game.
/////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillEntityAfterTime : MonoBehaviour
{
    //Variables to assign via the unity inspector.
    [SerializeField] private float m_timeTillDestruction = 3.0f;
	[SerializeField] private EntityHealth m_entityToKill;

	//Unity Functions
	private IEnumerator Start() {
		yield return new WaitForSeconds(m_timeTillDestruction);
		Debug.Log("Killing entity: " + m_entityToKill.gameObject.name);
		m_entityToKill.DamageEntity(10000000000000);
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Food : MonoBehaviour, IXPDropper {
	//Variables to assign via the unity inspector.
	[SerializeField] private int m_xpToDrop = 5;

	//Public Functions.
	public int CollectXP() {
		return m_xpToDrop;
	}

	//Unity Functions.
	private void OnValidate() {
		if(m_xpToDrop <= 0) {
			m_xpToDrop = 1;
		}
	}
}

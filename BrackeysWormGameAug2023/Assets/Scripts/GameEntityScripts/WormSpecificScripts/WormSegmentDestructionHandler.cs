/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: WormSegmentDestructionHandler.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To handle the destruction of the worm segments so that they properly destroy their bodies and drop food.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormSegmentDestructionHandler : MonoBehaviour, IDestructionHandler {
	//Variables to assign via the unity inspector.
	[SerializeField] private int m_foodToDropCount = 2;
	[SerializeField] private float m_dropRadius = 0.5f;

	//Public Functions.
	public void HandleObjectDestruction() {
		SpawnFood();
		Destroy(this.gameObject, 1.0f);
	}

	//Private Functions.
	private void SpawnFood() {
		for(int i = 0; i < m_foodToDropCount; i++) {
			Transform newFood = GameFoodSpawner.Instance.SpawnFood(this.transform.position, this.transform.parent.localScale, m_dropRadius);
		}
	}
}

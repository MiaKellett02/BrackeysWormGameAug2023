///////////////////////////////////////////////////////////////////////////
/// Filename: AntDestructionHandler.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: To handle the destruction/death of an ant entity.
///////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AntDestructionHandler : MonoBehaviour, IDestructionHandler {
	//Variables to assign via the unity inspector.
	[SerializeField] private int m_foodToDropCount = 2;
	[SerializeField] private float m_dropRadius = 0.5f;

	//Public Functions.
	public void HandleObjectDestruction() {
		//Spawn the food for the ants death.
		SpawnFood();

		//Destroy the ant one this has been done.
		Destroy(this.gameObject);
	}

	//Private Functions.
	private void SpawnFood() {
		for (int i = 0; i < m_foodToDropCount; i++) {
			Transform newFood = GameFoodSpawner.Instance.SpawnFood(this.transform.position, this.transform.parent.localScale, m_dropRadius);
		}
	}
}

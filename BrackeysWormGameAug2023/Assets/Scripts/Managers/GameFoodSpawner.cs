////////////////////////////////////////////////////////////////////////////
/// Filename: GameFoodSpawner.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To spawn food and ensure all food is under one parent.
////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFoodSpawner : MonoBehaviour {
	//Singleton.
	public static GameFoodSpawner Instance { get; private set; }

	//Variables to assign via the unity inspector.
	[SerializeField] private Transform m_foodPrefab;

	//Public Functions.
	public Transform SpawnFood(Vector3 a_position, Vector3 a_scale, float a_dropRadius) {
		Transform newFood = Instantiate(m_foodPrefab, this.transform);
		newFood.position = a_position + (GetRandomDirection() * a_dropRadius);
		newFood.localScale = a_scale;

		return newFood;
	}

	//Unity Functions.
	private void Awake() {
		Instance = this;
	}

	//Private Functions.
	private Vector3 GetRandomDirection() {
		Vector2 randomDirectionVec2 = new Vector2(Random.Range(-100.0f, 100.0f), Random.Range(-100.0f, 100.0f));
		randomDirectionVec2.Normalize();

		return new Vector3(randomDirectionVec2.x, randomDirectionVec2.y, 0.0f);
	}
}

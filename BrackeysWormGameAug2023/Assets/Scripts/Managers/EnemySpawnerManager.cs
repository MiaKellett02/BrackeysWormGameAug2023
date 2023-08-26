////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: EnemySpawnerManager.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To spawn enemies and change their difficulty based on how deep the player is.
////////////////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawnerManager : MonoBehaviour {
	//Singleton.
	public static EnemySpawnerManager Instance {
		get; private set;
	}

	//Variables to assign via the unity inspector.
	[Header("Enemy Prefabs")]
	[SerializeField] private Transform m_antPrefab;
	[SerializeField] private Transform m_molePrefab;
	[Header("Difficulty Settings.")]
	[SerializeField] private float m_maxEnemyDifficultyScale = 5.0f;
	[SerializeField] private AnimationCurve m_enemyDifficultyCurve;

	//Private Variables.
	private static System.Random rng = null;

	//Public Functions
	public void SpawnEnemy(Vector3 a_positionToSpawnAt) {
		//Get the difficulty depth multiplier.
		float playerDepthNormalized = Mathf.Clamp(-PlayerLocationTracker.Instance.GetPlayerPosition().y, 0.0f, WormGameManager.MAX_DEPTH_UNDERGROUND) / WormGameManager.MAX_DEPTH_UNDERGROUND;
		float enemyDifficultyMultiplier = m_enemyDifficultyCurve.Evaluate(playerDepthNormalized);

		//Choose a prefab to spawn at random.
		int chanceToChooseTheMolePrefab = (int)(enemyDifficultyMultiplier * 100);
		Transform prefabToUse = ChooseAnEnemyAtRandom(chanceToChooseTheMolePrefab);

		//Spawn the enemy and put it in the correct position..
		Transform newEnemy = Instantiate(prefabToUse, this.transform);
		newEnemy.position = GameBoundaryManager.Instance.EnsurePositionIsInsideTheBounds(a_positionToSpawnAt);
	}

	//Unity Functions.
	private void Awake() {
		Instance = this;
	}

	//Private Functions
	/// <summary>
	/// Picks an enemy at random, has a higher chance to pick the more difficult mole enemy at higher percentages.
	/// Will more likely choose the ant enemy when difficulty is lower.
	/// </summary>
	/// <param name="chancetoChooseAMoleEnemy"></param>
	public Transform ChooseAnEnemyAtRandom(int chancetoChooseAMoleEnemy) {
		// Seed
		if (rng == null) {
			rng = new System.Random(DateTime.Now.Millisecond);
		}

		// By chance
		if (rng.Next(100) < chancetoChooseAMoleEnemy) {
			return m_molePrefab;
		} else {
			return m_antPrefab;
		}
	}
}

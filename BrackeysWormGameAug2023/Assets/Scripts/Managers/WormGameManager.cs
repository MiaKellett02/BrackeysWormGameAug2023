////////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: WormGameManager.cs
/// Author: Mia Kellett
/// Date Created: 25/08/2023
/// Purpose: To control the flow of the game and what challenges/rewards are presented to the player.
/////////////////////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormGameManager : MonoBehaviour {
	//Consts.
	public const float MAX_DEPTH_UNDERGROUND = 100.0f;

	//Events
	public event EventHandler OnGameOver;

	//Enums
	[System.Serializable]
	public enum GameState {
		Playing,
		Paused,
		GameOver,
	}

	//Singleton
	public static WormGameManager Instance {
		get; private set;
	}

	//Variables to assign via the unity inspector.
	[Header("General Game Variables")]
	[SerializeField] private GameState m_startingState = GameState.Playing;
	[Header("Food Spawning Variables")]
	[SerializeField] private float m_foodToSpawnPerSecond = 0.1f;
	[SerializeField] private float m_foodMaxSpawningRadius = 30.0f;
	[Header("Enemy Spawning Variables")]
	[SerializeField] private float m_baseEnemiesToSpawnPerSecond = 0.1f;
	[SerializeField] private float m_enemiesMinSpawningRadius = 10.0f;

	//Private variables.
	//General Game Variables.
	private GameState m_currentGameState;

	//Food Spawning Variables.
	private float m_timeBetweenSpawningFood;
	private float m_spawnFoodTimer = 0.0f;

	//Enemy Spawning Variables.
	private float m_timeBetweenSpawningEnemies;
	private float m_spawnEnemiesTimer = 0.0f;

	//Public Functions.

	//Unity Functions.
	private void Awake() {
		Instance = this;
		m_currentGameState = m_startingState;//Set up the game state.
											 //FoodStuff.
		m_timeBetweenSpawningFood = 1 / m_foodToSpawnPerSecond; //Calculate how quickly food should spawn.
		m_spawnFoodTimer = m_timeBetweenSpawningFood;//Start timer at max.
													 //EnemyStuff.
		m_timeBetweenSpawningEnemies = 1 / m_baseEnemiesToSpawnPerSecond;
		m_spawnEnemiesTimer = m_timeBetweenSpawningEnemies;
	}

	private void Start() {
		//Listen to the player death event.
		PlayerDeathBroadcaster.OnPlayerDeath += PlayerDeathBroadcaster_OnPlayerDeath;
	}

	private void Update() {
		HandleGameStates();
	}

	//Private Functions.
	//Event Listeners.
	private void PlayerDeathBroadcaster_OnPlayerDeath(object sender, EventArgs e) {
		HandlePlayerDeath();
	}

	//Game State Handling.
	private void HandleGameStates() {
		switch (m_currentGameState) {
			case GameState.Playing: {
				HandleFoodSpawning();
				HandleEnemySpawning();
				break;
			}
			case GameState.Paused: {
				break;
			}
			case GameState.GameOver:
				HandleGameOver();
				break;
			default: {
				break;
			}
		}
	}
	//Game Playing Functions.
	private void HandleFoodSpawning() {
		if (m_spawnFoodTimer <= 0.0f) {
			//Reset timer.
			m_spawnFoodTimer = m_timeBetweenSpawningFood;

			//Spawn the food at a random position around the player..
			float minFoodDistance = 1.0f;
			float foodSpawningRadius = UnityEngine.Random.Range(minFoodDistance, m_foodMaxSpawningRadius);
			Vector3 positionToSpawnFood = GetRandomPositionAroundThePlayerUnitCircle() * foodSpawningRadius;
			GameFoodSpawner.Instance.SpawnFood(positionToSpawnFood, Vector3.one, 1.0f);
		} else {
			//Countdown the timer.
			m_spawnFoodTimer -= Time.deltaTime;
		}
	}

	private void HandleEnemySpawning() {
		if (m_spawnEnemiesTimer <= 0.0f) {
			//Reset timer.
			m_spawnEnemiesTimer = m_timeBetweenSpawningEnemies;

			//Spawn the food at a random position around the player..
			Vector3 positionToSpawnEnemy = GetRandomPositionAroundThePlayerUnitCircle() * m_enemiesMinSpawningRadius;
			EnemySpawnerManager.Instance.SpawnEnemy(positionToSpawnEnemy);
		} else {
			//Countdown the timer.
			m_spawnEnemiesTimer -= Time.deltaTime;
		}
	}

	//Game Paused Functions.

	//Game Over Functions.
	private void HandlePlayerDeath() {
		//GAME IS OVER.
		//Broadcast that the game is over.
		OnGameOver?.Invoke(this, EventArgs.Empty);

		//Set the state to game over.
		m_currentGameState = GameState.GameOver;
	}

	private void HandleGameOver() {

	}

	//Utility Functions.
	private Vector3 GetRandomPositionAroundThePlayerUnitCircle() {
		//Get the player position.
		Vector3 playerPosition = PlayerLocationTracker.Instance.GetPlayerPosition();

		//Get a random position around the player and return it.
		Vector2 randomDirVec2 = new Vector2(UnityEngine.Random.Range(-100.0f, 100.0f), UnityEngine.Random.Range(-100.0f, 100.0f));
		randomDirVec2.Normalize();
		Vector3 randomDir = new Vector3(randomDirVec2.x, randomDirVec2.y, 0.0f);
		return (playerPosition + randomDir);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: EntityHealth.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: To track the health of an entity.
////////////////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EntityHealth : MonoBehaviour, IDamageable {
	//Events.
	public event EventHandler OnEntityDamaged;
	public event EventHandler OnEntityHealed;
	public event EventHandler OnEntityDeath;
	public event EventHandler OnMaxHealthChanged;

	//Variables to assign via the unity inspector.
	[SerializeField] private MonoBehaviour m_entityDeathHandlerScript;

	[field: SerializeField]
	public float m_maxHealth {
		get; private set;
	} = 10.0f;

	//Properties.
	public float m_currentHealth {
		get; private set;
	}

	//Private Variables.
	private IDestructionHandler m_entityDestructionHandler;

	//Public Functions.
	public void DamageEntity(float a_damage) {
		//Subtract the health.
		m_currentHealth -= a_damage;

		//Broadcast the damage entity event.
		OnEntityDamaged?.Invoke(this, EventArgs.Empty);

		//Check if it has died.
		if (m_currentHealth <= 0) {
			HandleEntityDeath();
		}
	}

	public void HealEntity(float a_amountToHeal) {
		//Add the health.
		m_currentHealth += a_amountToHeal;
		if (m_currentHealth > m_maxHealth) {
			//Ensure it doesn't go over the max.
			m_currentHealth = m_maxHealth;
		}

		//Broadcast the heal entity event.
		OnEntityHealed?.Invoke(this, EventArgs.Empty);
	}

	public void IncreaseMaxHealth(float a_amountToIncreaseBy) {
		//Increase the max health.
		m_maxHealth += a_amountToIncreaseBy;

		//Broadcast the max health changed event.
		OnMaxHealthChanged?.Invoke(this, EventArgs.Empty);
	}

	public float GetCurrentHealthNormalized() {
		return Mathf.Clamp01((m_currentHealth / m_maxHealth));
	}

	public void HealToMax() {
		m_currentHealth = m_maxHealth;
		//Broadcast the heal entity event.
		OnEntityHealed?.Invoke(this, EventArgs.Empty);
	}

	//Unity Functions.
	private void Awake() {
		m_currentHealth = m_maxHealth;
		SetupDestructionHandler();
	}

	//Private Functions.
	private void HandleEntityDeath() {
		//Broadcast the death event.
		OnEntityDeath?.Invoke(this, EventArgs.Empty);

		//Destroy the entity object in the way specified by the death handler.
		if (m_entityDestructionHandler != null) {
			m_entityDestructionHandler.HandleObjectDestruction();
		}
	}

	private void SetupDestructionHandler() {
		if (m_entityDeathHandlerScript != null && m_entityDeathHandlerScript.TryGetComponent(out IDestructionHandler destructionHandler)) {
			m_entityDestructionHandler = destructionHandler;
		} else if (m_entityDeathHandlerScript != null && m_entityDestructionHandler == null) {
			Debug.LogError("Attached Script does not inherit from IDestructionHandler, please attach a valid Destruction Handler script");
		}
	}
}

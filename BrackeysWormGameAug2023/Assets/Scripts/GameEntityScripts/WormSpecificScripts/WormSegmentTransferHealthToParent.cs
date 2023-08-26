//////////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: WormSegmentTransferHealthToParent.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To transfer health to the worm segments parent segment so it goes to the head health.
//////////////////////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormSegmentTransferHealthToParent : MonoBehaviour, IDamageable {
	//Variables to assign via the unity inspector.
	[SerializeField] private MonoBehaviour m_wormSegmentParentDamageableScript;

	//Private Variables.
	private IDamageable m_damageable;

	//Public functions.
	public void DamageEntity(float a_damage) {
		m_damageable.DamageEntity(a_damage);
	}

	public void HealEntity(float a_amountToHeal) {
		m_damageable.HealEntity(a_amountToHeal);
	}

	public void IncreaseMaxHealth(float a_amountToIncreaseBy) {
		m_damageable.IncreaseMaxHealth(a_amountToIncreaseBy);
	}

	//Unity Functions.
	private void Awake() {
		SetupDamageableScript();

	}

	private void OnValidate() {
		SetupDamageableScript();
	}

	//Utility.
	private void SetupDamageableScript() {
		if (m_wormSegmentParentDamageableScript != null && m_wormSegmentParentDamageableScript.gameObject.TryGetComponent(out IDamageable damageableComponent)) {
			m_damageable = damageableComponent;
		} else if (m_wormSegmentParentDamageableScript != null && m_damageable == null) {
			Debug.LogError("Attached Script does not inherit from IDamageable, please attach a valid health/damageable script");
		}
	}
}

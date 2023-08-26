/////////////////////////////////////////////////////////////////////////////////
/// Filename: EntityGenericAttack.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To be a generic attack all entities can use without a specific one.
/////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// This attack is just a simple trigger collider that damages any entity health scripts that aren't part of the same faction as this entity.
/// </summary>
public class EntityGenericAttack : MonoBehaviour, ICanAttack {
	//Variables to assign via the unity inspector.
	[SerializeField] private EntityFactionIdentifier m_thisEntitysFactionIdentifier;
	[SerializeField] private float m_attackDamage = 5.0f;
	[SerializeField] private float m_attackCooldownTime = 1.0f;

	//Private Variables.
	private EntityHealth m_entityToAttack = null;
	private bool m_canAttackAgain = true;

	//Public Functions.
	public void Attack() {
		if (m_entityToAttack != null && m_canAttackAgain) {
			m_entityToAttack.DamageEntity(m_attackDamage);
		}
	}

	//Unity Functions.
	private void OnTriggerEnter2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			//Check what faction the other entity is a part of.
			if (entityFactionIdentifier.GetEntityFaction() == m_thisEntitysFactionIdentifier.GetEntityFaction()) {
				//Can't attack.
				return;
			}

			//Check if it has a health script.
			if (collision.TryGetComponent(out EntityHealth entityHealth)) {
				//Attack it.
				m_entityToAttack = entityHealth;
				StartCoroutine(AttackCooldown());
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			//Check what faction the other entity is a part of.
			if (entityFactionIdentifier.GetEntityFaction() == m_thisEntitysFactionIdentifier.GetEntityFaction()) {
				//Can't attack.
				return;
			}

			//Check if it has a health script.
			if (collision.TryGetComponent(out EntityHealth entityHealth)) {
				//Stop the script from attacking it.
				m_entityToAttack = null;
				StopAllCoroutines();
			}
		}
	}

	//Private Functions.
	private IEnumerator AttackCooldown() {
		while (m_entityToAttack != null) {
			Attack();
			m_canAttackAgain = false;
			yield return new WaitForSeconds(m_attackCooldownTime);
			m_canAttackAgain = true;
		}
	}
}

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIAttackTrigger : MonoBehaviour {
	//Events.
	public event EventHandler<OnAiAttackTriggeredEventArgs> OnAiAttackTriggered;
	public event EventHandler<OnAiAttackTriggeredEventArgs> OnAiAttackStopped;
	public class OnAiAttackTriggeredEventArgs : EventArgs {
		public Transform creatureThatTriggeredAttack;
		public Factions factionOfCreature;
	}

	//Variables to assign via the unity inspector.
	[SerializeField] EntityFactionIdentifier m_aiFactionIdentifier;

	//Unity Functions
	private void OnTriggerEnter2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			if (m_aiFactionIdentifier.GetEntityFaction() != entityFactionIdentifier.GetEntityFaction()) {
				OnAiAttackTriggeredEventArgs e = new OnAiAttackTriggeredEventArgs {
					creatureThatTriggeredAttack = collision.transform,
					factionOfCreature = entityFactionIdentifier.GetEntityFaction()
				};
				OnAiAttackTriggered?.Invoke(this, e);
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			if (m_aiFactionIdentifier.GetEntityFaction() != entityFactionIdentifier.GetEntityFaction()) {
				OnAiAttackTriggeredEventArgs e = new OnAiAttackTriggeredEventArgs {
					creatureThatTriggeredAttack = collision.transform,
					factionOfCreature = entityFactionIdentifier.GetEntityFaction()
				};
				OnAiAttackStopped?.Invoke(this, e);
			}
		}
	}
}

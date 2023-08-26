////////////////////////////////////////////////////////////////////////////////////
/// Filename: AIAggroTrigger.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To alert the AI when it should aggro.
////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIAggroTrigger : MonoBehaviour {
	//Events.
	public event EventHandler<OnAiAggroEventArgs> OnAiAggro;
	public event EventHandler<OnAiAggroEventArgs> OnAiStopAggro;
	public class OnAiAggroEventArgs : EventArgs {
		public Transform creatureThatCausedAggro;
		public Factions factionOfCreature;
	}

	//Variables to assign via the unity inspector.
	[SerializeField] EntityFactionIdentifier m_aiFactionIdentifier;

	//Unity Functions
	private void OnTriggerEnter2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			if (m_aiFactionIdentifier.GetEntityFaction() != entityFactionIdentifier.GetEntityFaction()) {
				OnAiAggroEventArgs e = new OnAiAggroEventArgs {
					creatureThatCausedAggro = collision.transform,
					factionOfCreature = entityFactionIdentifier.GetEntityFaction()
				};
				OnAiAggro?.Invoke(this, e);
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision) {
		if (collision.TryGetComponent(out EntityFactionIdentifier entityFactionIdentifier)) {
			if (m_aiFactionIdentifier.GetEntityFaction() != entityFactionIdentifier.GetEntityFaction()) {
				OnAiAggroEventArgs e = new OnAiAggroEventArgs {
					creatureThatCausedAggro = collision.transform,
					factionOfCreature = entityFactionIdentifier.GetEntityFaction()
				};
				OnAiStopAggro?.Invoke(this, e);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////
/// Filename: EntityFactionIdentifier.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To hold the data for what faction the attached entity is a part of.
////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EntityFactionIdentifier : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private Factions m_entityFaction = Factions.Enemy;

	//Public Functions.
	public Factions GetEntityFaction() {
		return m_entityFaction;
	}

	public void SetEntityFaction(Factions a_newFaction) {
		m_entityFaction = a_newFaction;
	}
}

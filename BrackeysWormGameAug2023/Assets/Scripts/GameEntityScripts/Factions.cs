////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: Factions.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: A basic enum to determine what faction an entity is part of.
////////////////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Entities on the player Faction will be friendly to the player.
/// Entities on the enemy faction will be hostile to the player.
/// Entities on the Free For ALl Faction will be hostile to all entites.
/// </summary>
public enum Factions {
	Player,
	Enemy,
	FreeForAll, 
}

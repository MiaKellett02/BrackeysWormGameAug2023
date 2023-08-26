//////////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: IDamageable.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To act as a contract for what functions should exist when something can be damaged.
//////////////////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IDamageable {
	public void DamageEntity(float a_damage);

	public void HealEntity(float a_amountToHeal);

	public void IncreaseMaxHealth(float a_amountToIncreaseBy);
}

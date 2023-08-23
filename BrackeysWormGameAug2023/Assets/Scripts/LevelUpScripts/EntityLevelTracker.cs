////////////////////////////////////////////////////////////////////////////////////
/// Filename: EntityLevelTracker.cs
/// Author: Mia Kellett
/// Date Created: 23/08/2023
/// Purpose: To track the level of any entity using this class.
////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EntityLevelTracker : MonoBehaviour {
	//Events.
	public event EventHandler onEntityLevelUp;

	//Variables to assign via the unity inspector.
	[SerializeField] private int m_maxLevel;
	[SerializeField] private int m_baseXPToLevelUp = 1000;
	[SerializeField] private AnimationCurve m_levelUpCurve;

	//Private Variables.
	private LevelTrackingData m_levelTrackingData;

	//Public Functions.
	/// <summary>
	/// Gives the entity instance referenced the XP from the class that implements the interface passed in as a parameter.
	/// </summary>
	/// <param name="a_xpDropper"></param>
	public void GiveXPToEntityFromXPDropper(IXPDropper a_xpDropper) {
		int xpFromTarget = a_xpDropper.CollectXP();
		m_levelTrackingData.m_currentXP += xpFromTarget;
		CheckIfShouldEntityLevelUp();
	}

	public int GetCurrentXP() {
		return m_levelTrackingData.m_currentXP;
	}

	public int GetXPToLevelUp() {
		return m_levelTrackingData.m_xpRequiredToLevelUp;
	}

	public float GetXPNormalised() {
		return (float) m_levelTrackingData.m_currentXP / (float)m_levelTrackingData.m_xpRequiredToLevelUp;
	}

	//Unity Functions.
	private void Awake() {
		m_levelTrackingData = new LevelTrackingData();
		UpdateLevelTrackingDataAfterLevelUp();
	}

	private void OnValidate() {
		if (m_maxLevel <= 0) {
			m_maxLevel = 1;
		}
		if(m_baseXPToLevelUp <= 0) {
			m_baseXPToLevelUp = 1;
		}
	}

	//Private Functions.
	private void CheckIfShouldEntityLevelUp() {
		if(m_levelTrackingData.m_currentXP >= m_levelTrackingData.m_xpRequiredToLevelUp) {
			UpdateLevelTrackingDataAfterLevelUp();
			onEntityLevelUp?.Invoke(this, EventArgs.Empty);
		}
	}

	private void UpdateLevelTrackingDataAfterLevelUp() {
		m_levelTrackingData.m_currentLevel += 1; //Increment level counter.
		m_levelTrackingData.m_currentXP = 0; //Reset up count to 0.

		//Update xp required to level up.
		float levelNormalised = (float)m_levelTrackingData.m_currentLevel / (float)m_maxLevel;
		int difficultyCurveMultiplier = Mathf.RoundToInt(1.0f / m_levelUpCurve.Evaluate(levelNormalised));
		m_levelTrackingData.m_xpRequiredToLevelUp = m_baseXPToLevelUp * difficultyCurveMultiplier;
	}


	//Data holders.
	private class LevelTrackingData {
		public int m_currentXP;
		public int m_xpRequiredToLevelUp;
		public int m_currentLevel;
	}
}

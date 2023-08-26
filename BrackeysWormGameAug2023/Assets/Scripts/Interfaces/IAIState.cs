//////////////////////////////////////////////////////////////////////
/// Filename: IAIState.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: An interface with basic functions for the AI states.
//////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IAIState {
	public void EnterState();
	public void ExitState();
	public void StateUpdate();
	public void StateFixedUpdate();
}

//////////////////////////////////////////////////////////////////
/// Filename: ICanMove.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: To indicate that something can be moved/Controlled.
//////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICanMove {
	public void TurnRight();
	public void TurnLeft();
	public void MoveForward();
}

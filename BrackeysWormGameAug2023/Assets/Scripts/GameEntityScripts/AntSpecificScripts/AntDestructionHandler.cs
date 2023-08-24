///////////////////////////////////////////////////////////////////////////
/// Filename: AntDestructionHandler.cs
/// Author: Mia Kellett
/// Date Created: 24/08/2023
/// Purpose: To handle the destruction/death of an ant entity.
///////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AntDestructionHandler : MonoBehaviour, IDestructionHandler {
	public void HandleObjectDestruction() {
		//FOR NOT JUST DESTROY IT.
		//TODO:: HANDLE DEATH ANIMATIONS AND SOUNDS
		Destroy(this.gameObject);
	}
}

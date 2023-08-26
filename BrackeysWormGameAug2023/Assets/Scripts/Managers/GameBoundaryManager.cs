/////////////////////////////////////////////////////////////////////////////
/// Filename: GameBoundaryManager.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose to keep entities within the bounds of the game.
/////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameBoundaryManager : MonoBehaviour {
	//Singleton.
	public static GameBoundaryManager Instance {
		get; private set;
	}

	//Variables to assign via the unity inspector.
	[SerializeField] private float m_levelWidth = 30.0f;

	//Public Functions.
	public Vector3 EnsurePositionIsInsideTheBounds(Vector3 a_position) {
		Vector3 newPos = a_position;
		if (newPos.y > 0.0f) {
			newPos.y = 0.0f;//Ensure is below the ground.
		} else if (newPos.y < -WormGameManager.MAX_DEPTH_UNDERGROUND) {
			newPos.y = -WormGameManager.MAX_DEPTH_UNDERGROUND;//Ensure it isn't too deep.
		}

		if (newPos.x < -(m_levelWidth / 2)) {
			newPos.x = -(m_levelWidth / 2);//Ensure it's within the left bound.
		} else if (newPos.x > m_levelWidth / 2) {
			newPos.x = m_levelWidth / 2;//Ensure it's within the right bound.
		}

		return newPos;
	}

	//Unity Functions.
	private void Awake() {
		Instance = this;
	}

	private void OnDrawGizmos() {
		Gizmos.color = Color.yellow;
		Vector3 gizmoPos = new Vector3(0.0f, -(WormGameManager.MAX_DEPTH_UNDERGROUND / 2), 0.0f);
		Vector3 gizmoSize = new Vector3(m_levelWidth, WormGameManager.MAX_DEPTH_UNDERGROUND, 1.0f);
		Gizmos.DrawWireCube(gizmoPos, gizmoSize);
	}

	//Private Functions.

}

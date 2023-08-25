///////////////////////////////////////////////////////////////////////
/// Filename: WormSegmentBase.cs
/// Author: Mia Kellett
/// Date Created: 22/08/2023
/// Purpose: To ensure each worm segment follows the one infront of it.
///////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(WormSegmentDestructionHandler))]
public class WormSegmentBase : MonoBehaviour {
	//static.
	private static float s_movementOverTime = 0.5f;
	private static float s_minDistanceFromParent = 0.5f;

	//Properties.
	public bool IsWormHead {
		get; protected set;
	}

	//Variables.
	[SerializeField] protected WormSegmentBase m_childSegment = null;
	protected Vector3 movementVelocity;

	//Unity Functions.
	protected virtual void Awake() {
		IsWormHead = false;
	}

	//Public Base Functions
	public virtual void MakeChildFollowThisParent(WormSegmentBase a_parentSegment) {
		if (a_parentSegment == null) {
			Debug.LogError("Parent segment for " + this.gameObject.transform.position + " has not been assigned.");
			return;
		}
		//Get the new position.
		Vector3 newPosition = Vector3.SmoothDamp(transform.position, a_parentSegment.transform.position, ref movementVelocity, s_movementOverTime);

		//Check if it's outisde the minimum distance from the parent.
		float distanceFromParentAtNewPosSqr = (a_parentSegment.transform.position - newPosition).sqrMagnitude;
		bool isValidPosition = distanceFromParentAtNewPosSqr > (s_minDistanceFromParent * s_minDistanceFromParent);
		if (isValidPosition) {
			transform.position = newPosition;
		}

		//transform.up = Vector3.Slerp(transform.up, a_parentSegment.transform.up, s_movementOverTime);

		//Once this child has followed the parent, make it's child follow it.
		if (m_childSegment != null) {
			m_childSegment.MakeChildFollowThisParent(this);
		}
	}

	public WormSegmentBase GetChild() {
		return m_childSegment;
	}

	//Private Functions.
	protected static void SetMovementOverTime(float a_movementOverTime) {
		s_movementOverTime = Mathf.Clamp01(a_movementOverTime);
	}

	protected static void SetMinDistanceFromParent(float a_minDistanceFromParent) {
		s_minDistanceFromParent = a_minDistanceFromParent;
	}
}

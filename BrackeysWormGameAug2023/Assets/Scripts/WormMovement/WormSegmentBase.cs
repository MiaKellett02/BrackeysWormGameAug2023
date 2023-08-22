using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WormSegmentBase : MonoBehaviour {
	//static.
	private static float s_movementOverTime = 0.5f;

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
		transform.position = Vector3.SmoothDamp(transform.position, a_parentSegment.transform.position, ref movementVelocity, s_movementOverTime);
		//transform.LookAt(a_parentSegment.transform.position);
		transform.up = Vector3.Slerp(transform.up, a_parentSegment.transform.up, s_movementOverTime);

		//Once this child has followed the parent, make it's child follow it.
		if (m_childSegment != null) {
			m_childSegment.MakeChildFollowThisParent(this);
		}
	}

	//Private Functions.
	protected static void SetMovementOverTime(float a_movementOverTime) {
		s_movementOverTime = Mathf.Clamp01(a_movementOverTime);
	}
}

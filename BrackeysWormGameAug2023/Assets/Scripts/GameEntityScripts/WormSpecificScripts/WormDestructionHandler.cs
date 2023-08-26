/////////////////////////////////////////////////////////////////////////////
///
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(WormHeadMovementScript))]
public class WormDestructionHandler : MonoBehaviour, IDestructionHandler {
	//Variables to assign via the unity inspector.
	[SerializeField] private GameObject m_wormController;

	//Private Variables.
	private WormHeadMovementScript m_wormHeadMovementScript;//This has a reference to the worm's children segments.
	private List<WormSegmentBase> m_wormSegments;

	//Public Functions.
	public void HandleObjectDestruction() {
		//Destroy the worm controller.
		if (m_wormController != null) {
			Destroy(m_wormController);
		}

		//Get all the worm segments.
		GetAllWormSegments();

		//Make the segments destroy themselves.
		foreach (WormSegmentBase segment in m_wormSegments) {
			if (segment == null) {
				continue;
			}

			if (segment.TryGetComponent(out WormSegmentDestructionHandler destructionHandler)) {
				destructionHandler.HandleObjectDestruction();
			} else {
				Debug.LogError("Worm segment '" + segment.gameObject.name + "' has no destruction handler.");
			}
		}

		//Destroy the head.
		if (m_wormHeadMovementScript != null){
			m_wormHeadMovementScript.GetComponent<WormSegmentDestructionHandler>().HandleObjectDestruction();
		}

		//Destroy the worm as a whole.
		if (this != null && this.gameObject != null && this.gameObject.transform.parent != null) {
			Destroy(this.gameObject.transform.parent.gameObject);
		}
	}

	//Unity Functions.
	private void Start() {
		m_wormSegments = new List<WormSegmentBase>();
		m_wormHeadMovementScript = GetComponent<WormHeadMovementScript>();
	}

	//Private Functions
	private void GetAllWormSegments() {
		WormSegmentBase childSegment = m_wormHeadMovementScript.GetChild();
		while (childSegment != null) {
			//Add this segment to the list.
			m_wormSegments.Add(childSegment);

			//Move onto the next child.
			childSegment = childSegment.GetChild();
		}

		//Only gets here if there is no more children.
		//Reverse the list so we destroy the ones at the end first.
		m_wormSegments.Reverse();
	}
}

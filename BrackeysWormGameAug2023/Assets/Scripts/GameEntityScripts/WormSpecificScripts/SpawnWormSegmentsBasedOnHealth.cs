//////////////////////////////////////////////////////////////////////////////////////////////
/// Filename: SpawnWormSegmentsBasedOnHealth.cs
/// Author: Mia Kellett
/// Date Created: 26/08/2023
/// Purpose: To dynamically spawn the worm segments based on the health of the worm.
//////////////////////////////////////////////////////////////////////////////////////////////
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnWormSegmentsBasedOnHealth : MonoBehaviour {
	//Variables to assign via the unity inspector.
	[SerializeField] private int m_maxSegmentsToSpawn = 6;
	[SerializeField] private Transform m_wormSegmentPrefab;
	[SerializeField] private EntityLevelTracker m_wormLevelTracker;

	//Private Variables.
	private EntityHealth m_wormHealthScript;
	private List<Transform> m_wormSegments;
	private bool firstFrame = true;

	//Unity functions.
	private void Awake() {
		m_wormSegments = new List<Transform>();
	}

	private void Start() {
		m_wormHealthScript = this.gameObject.GetComponent<EntityHealth>();
		//Subscribe.
		m_wormHealthScript.OnEntityDamaged += WormHealthScript_OnEntityDamaged;
		m_wormHealthScript.OnEntityHealed += WormHealthScript_OnEntityHealed;
		m_wormHealthScript.OnMaxHealthChanged += WormHealthScript_OnMaxHealthChanged;
		m_wormLevelTracker.OnEntityLevelUp += WormLevelTracker_OnEntityLevelUp;
	}

	private void Update() {
		if (firstFrame) {
			firstFrame = false;
			//Update once on first update.
			UpdateWormSegments();
		}
	}

	private void OnDestroy() {
		//Unsubscribe.
		m_wormHealthScript.OnEntityDamaged -= WormHealthScript_OnEntityDamaged;
		m_wormHealthScript.OnEntityHealed -= WormHealthScript_OnEntityHealed;
		m_wormHealthScript.OnMaxHealthChanged -= WormHealthScript_OnMaxHealthChanged;
		m_wormLevelTracker.OnEntityLevelUp -= WormLevelTracker_OnEntityLevelUp;
	}

	//Private Functions.
	private void UpdateWormSegments() {
		//Get the number of segments that need to be spawned this update.
		float currentHealthNormalized = Mathf.Clamp01(m_wormHealthScript.m_currentHealth / m_wormHealthScript.m_maxHealth);
		int numSegmentsToSpawn = Mathf.RoundToInt((float)m_maxSegmentsToSpawn * currentHealthNormalized);
		Debug.Log("Num segments that should be spawned = " + numSegmentsToSpawn);

		if (m_wormSegments.Count > numSegmentsToSpawn) {
			//We need to destroy some at the end.
			for (int i = numSegmentsToSpawn; i < m_wormSegments.Count; i++) {
				Debug.Log("Destroying segment");
				Transform segment = m_wormSegments[m_wormSegments.Count - 1];
				m_wormSegments.Remove(segment);
				Destroy(segment.gameObject);
			}

			//Tell the new end it shouldn't reference anything else.
			if (m_wormSegments.Count > 0) {
				m_wormSegments[m_wormSegments.Count - 1].GetComponent<WormSegmentBase>().SetChild(null);
			}
		} else if (m_wormSegments.Count < numSegmentsToSpawn) {
			//We need to spawn some.
			int numToSpawn = numSegmentsToSpawn * m_wormSegments.Count;

			if (m_wormSegments.Count > 0) {
				for (int i = 0; i < numToSpawn; i++) {
					//Get the parent of the new segment.
					WormSegmentBase parentSegment = m_wormSegments[m_wormSegments.Count - 1].GetComponent<WormSegmentBase>();

					//Spawn it
					Transform newSegment = SpawnWormSegment(parentSegment);

					//Add it to the list.
					m_wormSegments.Add(newSegment);
				}
			} else {
				//Spawn 1 segment relative to the head object.
				Transform firstSegment = SpawnWormSegment(this.GetComponent<WormHeadMovementScript>());
				m_wormSegments.Add(firstSegment);
				UpdateWormSegments();
			}
		}

		if (m_wormSegments.Count > numSegmentsToSpawn) {
			UpdateWormSegments();
		}

		if (m_wormSegments.Count < numSegmentsToSpawn) {
			Debug.LogError("DIDN'T SPAWN ENOUGH WORM SEGMENTS");
		}
	}

	private Transform SpawnWormSegment(WormSegmentBase a_movementParent) {
		Debug.Log("Spawning new Segment");
		//Instatiate the new segment.
		Transform newSegment = Instantiate(m_wormSegmentPrefab, this.transform.parent);

		//Position it relative to the parent.
		newSegment.position = a_movementParent.transform.position;

		//Ensure it has the same faction as the parent.
		EntityFactionIdentifier entityFactionIdentifier = newSegment.GetComponent<EntityFactionIdentifier>();
		entityFactionIdentifier.SetEntityFaction(a_movementParent.GetComponent<EntityFactionIdentifier>().GetEntityFaction());

		//Set the parent's child movement script to this.
		WormSegmentBase segmentMovementScript = newSegment.GetComponent<WormSegmentBase>();
		a_movementParent.SetChild(segmentMovementScript);

		//Set the new segments child to null.
		segmentMovementScript.SetChild(null);

		//Set the new segments parent health script to the parent passed in.
		WormSegmentTransferHealthToParent transferHealthToParent = newSegment.GetComponent<WormSegmentTransferHealthToParent>();
		if (a_movementParent.TryGetComponent(out IDamageable damageableComponent)) {
			transferHealthToParent.SetParentDamageScript(damageableComponent);
		}

		return newSegment;
	}

	private void WormHealthScript_OnMaxHealthChanged(object sender, System.EventArgs e) {
		UpdateWormSegments();
	}

	private void WormHealthScript_OnEntityHealed(object sender, System.EventArgs e) {
		UpdateWormSegments();
	}

	private void WormHealthScript_OnEntityDamaged(object sender, System.EventArgs e) {
		UpdateWormSegments();
	}

	private void WormLevelTracker_OnEntityLevelUp(object sender, System.EventArgs e) {
		//Update the max number of segments that can be spawned.
		m_maxSegmentsToSpawn += 1;

		//Heal the entity to max.
		m_wormHealthScript.HealToMax();

		//Update the worm segments.
		UpdateWormSegments();
	}
}

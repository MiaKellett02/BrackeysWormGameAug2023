using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoaderCallback : MonoBehaviour
{
    //Variables.
    private bool canLoadNextScene = false;


	// Update is called once per frame
	private IEnumerator Start() {
		float randomWaitTime = Random.Range(0.5f, 3.0f);
		yield return new WaitForSeconds(randomWaitTime);
		canLoadNextScene = true;
	}

	void Update()
    {
		if (canLoadNextScene) {
			canLoadNextScene = false;
            Loader.LoaderCallback();
		}
    }
}

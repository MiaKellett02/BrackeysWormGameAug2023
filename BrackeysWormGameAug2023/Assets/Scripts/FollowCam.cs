using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowCam : MonoBehaviour
{
    [SerializeField] Transform followTransform;

    private void LateUpdate() {
        if (followTransform != null) {
            Vector3 followPos = new(followTransform.position.x, followTransform.position.y, transform.position.z);
            transform.position = followPos;
        }
    }
}

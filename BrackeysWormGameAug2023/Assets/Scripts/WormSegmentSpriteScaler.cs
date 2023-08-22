using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[ExecuteInEditMode]
public class WormSegmentSpriteScaler : MonoBehaviour
{
    private MaterialPropertyBlock m_propertyBlock;

    float m_currentScale;

    private void Start() {
        m_propertyBlock = new MaterialPropertyBlock();
    }

    private void Update() {

        if (m_currentScale != transform.transform.localScale.x) {
            m_propertyBlock = new MaterialPropertyBlock();
            m_propertyBlock.SetFloat("_Scale", transform.localScale.x);
            GetComponent<Renderer>().SetPropertyBlock(m_propertyBlock);

            m_currentScale = transform.localScale.x;
        }
    }
}

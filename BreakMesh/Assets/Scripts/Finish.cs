using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Finish : MonoBehaviour
{
    [SerializeField] protected GameObject endVFX;


    private void OnTriggerEnter(Collider other) {
        if (other.transform.tag == "Player") {
            endVFX.SetActive(true);
        }
    }
}

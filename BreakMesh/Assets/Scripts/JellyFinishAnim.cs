using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JellyFinishAnim : MonoBehaviour
{
    public void PlayAgain() {
        // Anim
		GetComponent<Animator>().Play("Win Dance", 0, 0.52f);
    }
}

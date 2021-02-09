using System.Collections;
using UnityEngine;

public class TimedKiller : MonoBehaviour
{
    void Start() {
        StartCoroutine(KillMe());
    }

    private IEnumerator KillMe() {
        yield return new WaitForSeconds(6f);
        Destroy(gameObject);
    }
}

using System.Collections;
using UnityEngine;

public class Ball : MonoBehaviour
{
	[HideInInspector] public bool IsHolding;

	private Rigidbody _rb;


	private void Awake () {
		_rb = GetComponent<Rigidbody> ();
	}

	public void Push (Vector2 force) {
		_rb.AddForce (force, ForceMode.Impulse);
		StartCoroutine(AvoidHoldingAWhile());
	}

	public void ActivateRb () {
		_rb.isKinematic = false;
	}

	public void DesactivateRb () {
		SlowDown(0);
		_rb.isKinematic = true;
	}

	public void SlowDown(float ratio) {
		_rb.velocity *= ratio;
		_rb.angularVelocity *= ratio;
	}

	public void Hold(float targetY) {
		IsHolding = true;
		DesactivateRb();
		StartCoroutine(ReachPoint(targetY));
	}

	private IEnumerator ReachPoint(float targetY) {
		Vector3 pos = transform.position;
		while (Mathf.Abs(pos.y - targetY) > 0.1f) {
			yield return new WaitForSeconds(Time.deltaTime);
			pos.y = Mathf.Lerp(pos.y, targetY, 0.07f);
			transform.position = pos;
		}
	}

	private IEnumerator AvoidHoldingAWhile() {
		yield return new WaitForSeconds(0.1f);
		IsHolding = false;
	}
}
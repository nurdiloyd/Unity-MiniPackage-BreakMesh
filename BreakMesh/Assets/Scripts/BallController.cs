using UnityEngine;

public class BallController : MonoBehaviour
{
	[SerializeField] protected Trajectory trajectory;
	[SerializeField] protected float pushForce;

	private Camera _camera;
	private Rigidbody _rb;
	private Breaker _breaker;
	
	private bool _isDragging;
	private Vector2 _startPoint;
	private Vector2 _endPoint;
	private Vector2 _direction;
	private Vector2 _force;
	private float _distance;
	private float _maxForce = 50;


	private void Start () {
		_camera = Camera.main;
		
		_rb = GetComponent<Rigidbody> ();
		_breaker = GetComponent<Breaker>();

		Time.timeScale = 1.5f;
	}

	private void Update () {		
		if (Input.GetMouseButtonDown(0)) {
			_isDragging = true;
			OnDragStart();
		}

		if (_isDragging) {
			OnDrag();
		}

		if (Input.GetMouseButtonUp(0)) {
			_isDragging = false;
			OnDragEnd();
		}
	}

	///*** Drag Operations ***///
	private void OnDragStart () {
		_startPoint = _camera.ScreenToViewportPoint(Input.mousePosition); // _camera.ScreenToWorldPoint(Input.mousePosition);

		// Trajectory
		trajectory.Show();
		
		Time.timeScale = 0.2f;
	}

	private void OnDrag () {
		_endPoint = _camera.ScreenToViewportPoint(Input.mousePosition); // _camera.ScreenToWorldPoint(Input.mousePosition);
		_distance = Vector2.Distance(_startPoint, _endPoint);
		_direction = (_startPoint - _endPoint).normalized;
		_force = _direction * _distance * pushForce;
		_force = Vector3.ClampMagnitude(_force, _maxForce);
		
		// Trajectory
		trajectory.UpdateDots(transform.position, _force);
	}

	private void OnDragEnd() {
		//push the ball
		_rb.isKinematic = false;
		_rb.AddForce (_force, ForceMode.Impulse);

		// Trajectory
		trajectory.Hide();
		
		Time.timeScale = 1.5f;
	}

	///*** Trigger ***///
	private void OnTriggerEnter(Collider other) {
		if (other.gameObject.tag == "Fragile") {
			Vector3 collPoint = other.gameObject.GetComponent<Collider>().ClosestPointOnBounds(transform.position); // other.contacts[0].point;

			// Breaking Bad
			var fracture = other.gameObject.GetComponent<Fracture>();
			_breaker.Break(fracture, collPoint);
		}
	}
}
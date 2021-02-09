using UnityEngine;

public class BallController : MonoBehaviour
{
	[SerializeField] protected Trajectory trajectory;
	[SerializeField] protected float pushForce;
	[SerializeField] protected Transform jelly;
	[SerializeField] protected ParticleSystem hitVFX;
	[SerializeField] protected ParticleSystem breakVFX;
	[SerializeField] protected ParticleSystem cutVFX;

	private GameManager _gameManager;
	private Camera _camera;
	private AudioManager _audioManager;
	
	private Ball _ball;
	private Breaker _breaker;
	private Animator _animator;
	
	private bool _isDragging;
	private Vector2 _startPoint;
	private Vector2 _endPoint;
	private Vector2 _direction;
	private Vector2 _force;
	private float _distance;
	private float _maxForce = 50;


	private void Start () {
		_gameManager = FindObjectOfType<GameManager>();
		_camera = Camera.main;
		_audioManager = FindObjectOfType<AudioManager>();
		
		_ball = GetComponent<Ball>();
		_breaker = GetComponent<Breaker>();
		_animator = jelly.GetChild(0).GetComponent<Animator>();

		Time.timeScale = 1.5f;
	}

	private void Update () {		
		if (_gameManager.CurrentLevel.LevelStarted){
			if (Input.GetMouseButtonDown(0)) {
				_isDragging = true;
				OnDragStart();
			}

			if (Input.GetMouseButtonUp(0)) {
				_isDragging = false;
				OnDragEnd();
			}

			if (_isDragging) {
				OnDrag();
			}
		}

		// Anim
		_animator.SetBool("IsHolding", _ball.IsHolding);

		if (_ball.IsHolding) {
			jelly.rotation = Quaternion.Slerp(jelly.rotation, Quaternion.identity, 10f * Time.deltaTime);
		}
	}

	///*** Drag Operations ***///
	private void OnDragStart () {
		// Taptuc
		TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Medium);
		// Anim
		_animator.SetBool("IsStretching", true);

		_startPoint = _camera.ScreenToViewportPoint(Input.mousePosition); // _camera.ScreenToWorldPoint(Input.mousePosition);

		trajectory.Show();
		
		Time.timeScale = 0.2f;
	}

	private void OnDrag () {
		// Anim
		_animator.Play((_ball.IsHolding ? "Hold" : "Air") + " Stretch", 0, _force.magnitude / _maxForce);

		_endPoint = _camera.ScreenToViewportPoint(Input.mousePosition); // _camera.ScreenToWorldPoint(Input.mousePosition);
		_distance = Vector2.Distance(_startPoint, _endPoint);
		_direction = (_startPoint - _endPoint).normalized;
		_force = _direction * _distance * pushForce;
		_force = Vector3.ClampMagnitude(_force, _maxForce);
		
		// Jelly Rotation
		Vector3 jellyEuler;
		jellyEuler = jelly.eulerAngles;
		jellyEuler.z = Vector3.SignedAngle(_direction, transform.up, -transform.forward);
		jelly.eulerAngles = jellyEuler;
		
		// Trajectory
		trajectory.UpdateDots(_ball.transform.position, _force);
	}

	private void OnDragEnd() {
		// Anim
		_animator.SetBool("IsStretching", false);
		// SFX	
		if (_force.magnitude > 6) {
			_audioManager.Play("Woosh");
		}

		//push the ball
		_ball.DesactivateRb();
		_ball.ActivateRb();
		_ball.Push(_force);

		trajectory.Hide();
		
		Time.timeScale = 1.5f;
	}

	///*** Trigger and Collision ***///
	private void OnTriggerEnter(Collider other) {
		if (other.tag == "Rope") {
			// Taptuc
			TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Medium);
			// VFX
			cutVFX.Play();
			// SFX
			_audioManager.Play("Cut");

			_ball.SlowDown(0.8f);
			other.GetComponent<Rope>().Cut();
		}
		else if (other.tag == "Holdable" && !_ball.IsHolding) {
			// Taptuc
			TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Heavy);
			// SFX
			_audioManager.Play("Hold");

			_ball.Hold(other.transform.position.y + 0.5f);
		}
		else if (other.tag == "Finish" && !_ball.IsHolding) {
			// Taptuc
			TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Heavy);
			// Anim
			_animator.SetBool("IsWon", true);
			// SFX
			_audioManager.Play("Hold");
			// Level Completed
			_gameManager.CurrentLevel.LevelCompleted();
			
			_ball.Hold(other.transform.position.y + 0.5f);
		}
		else if (other.gameObject.tag == "Fragile") {
			// Taptuc
			TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Heavy);
			// VFX
			Vector3 collPoint = other.gameObject.GetComponent<Collider>().ClosestPointOnBounds(transform.position); // other.contacts[0].point;
			breakVFX.transform.position = collPoint;
			breakVFX.Play();
			// SFX
			_audioManager.PlayOnMe("Hit", gameObject);
			_audioManager.Play("Break");

			// Slow Down Ball
			_ball.SlowDown(0.6f);

			// Breaking Bad
			var fracture = other.gameObject.GetComponent<Fracture>();
			_breaker.Break(fracture, collPoint);
		}
	}

	private void OnCollisionEnter(Collision other) {
		if (other.transform.tag == "Untagged") {
			// Taptuc
			TapticPlugin.TapticManager.Impact(TapticPlugin.ImpactFeedback.Light);
			// VFX
			hitVFX.transform.position = other.contacts[0].point;
			hitVFX.Play();
			// SFX
			_audioManager.PlayOnMe("Hit", gameObject);
		}
	}
}
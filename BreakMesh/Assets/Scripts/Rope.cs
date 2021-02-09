using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rope : MonoBehaviour
{
    private bool _isCutted;
    private MeshRenderer _renderer;
    private float _dissolve = 0;


    private void Start() {
        _renderer = GetComponent<MeshRenderer>();
    }

    private void Update() {
        if (_isCutted) {
            _dissolve = Mathf.Lerp(_dissolve, 1, 2f * Time.deltaTime);
            _renderer.material.SetFloat("_DissolveAmount", _dissolve);
        }

        if (_dissolve > 0.9f) {
            Destroy(gameObject);
        }
    }

    public void Cut() {
        _isCutted = true;
    }
}

using UnityEngine;
using System.Collections;

public class SetQueue1 : MonoBehaviour {
    public int renderQueue;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        Renderer rend = GetComponent<Renderer>();
        rend.sharedMaterial.renderQueue = renderQueue;
	
	}
}

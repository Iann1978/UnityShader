using UnityEngine;
using System.Collections;

public class VolumeFogCamera : MonoBehaviour {

	// Use this for initialization
	void Start () {
        
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnPreRender() {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}

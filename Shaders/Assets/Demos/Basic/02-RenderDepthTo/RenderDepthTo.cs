using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderDepthTo : MonoBehaviour {

    public Shader shader;
    Camera shaderCamera;
    public RenderTexture renderTexture;

    // Use this for initialization
    void Start ()
    {
        shaderCamera = new GameObject("Depth Camera", typeof(Camera)).GetComponent<Camera>();
        shaderCamera.CopyFrom(Camera.main);
        //shaderCamera.gameObject.SetActive(false)
        shaderCamera.SetReplacementShader(shader, "RenderType");
        shaderCamera.targetTexture = renderTexture;
        shaderCamera.clearFlags = CameraClearFlags.SolidColor;
        shaderCamera.backgroundColor = Color.white;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}

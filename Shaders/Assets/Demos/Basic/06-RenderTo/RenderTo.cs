using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderTo : MonoBehaviour {

    Camera shaderCamera;
	// Use this for initialization
	void Start () {
        //GameObject goShaderCamera = new GameObject("ShaderCamera", typeof(Camera));
        //shaderCamera = goShaderCamera.GetComponent<Camera>();
        //shaderCamera.CopyFrom(Camera.main);
        //RenderTexture targetTexture = new RenderTexture(Screen.width, Screen.height, 24,RenderTextureFormat.Depth);
        //shaderCamera.targetTexture = targetTexture;
        ////RenderBuffer colorBuff = new RenderBuffer();
        ////shaderCamera.SetTargetBuffers(colorBuffer, null);
        //Renderer renderer = GetComponent<Renderer>();
        //renderer.material.SetTexture("_MainTex", targetTexture);

        Camera camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;
        
    }
	

	// Update is called once per frame
	void Update () {
		
	}

    void OnGUI()
    {
    }
}

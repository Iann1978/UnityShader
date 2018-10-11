using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Thickness : MonoBehaviour {

    public Shader depthShader;
    public Camera shaderCamera;
    public RenderTexture depthTexture;
	// Use this for initialization
	void Start () {

        shaderCamera = new GameObject("Shader Camera", typeof(Camera)).GetComponent<Camera>();
        shaderCamera.CopyFrom(Camera.main);
        shaderCamera.gameObject.SetActive(false);
        shaderCamera.clearFlags = CameraClearFlags.SolidColor;
        shaderCamera.backgroundColor = Color.white;

        depthTexture = new RenderTexture(shaderCamera.pixelWidth, shaderCamera.pixelHeight, 32, RenderTextureFormat.Default);
        shaderCamera.targetTexture = depthTexture;        
        Renderer renderer = GetComponent<Renderer>();
        renderer.material.SetTexture("_DepthTexture", depthTexture);



    }
	
	// Update is called once per frame
	void Update () {
		
	}

    private void OnRenderObject()
    {
        Debug.Log("OnPreRender");
        shaderCamera.RenderWithShader(depthShader, "RenderType");
        Renderer renderer = GetComponent<Renderer>();
        renderer.material.SetTexture("_DepthTexture", depthTexture);
    }

}

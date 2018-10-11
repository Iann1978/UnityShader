using UnityEngine;
using System.Collections;

public class ShowDeapthPlane : MonoBehaviour {

    public Camera   mainCamera;
    public Shader   depthShader;
    Camera          depthCamera;   // 用于渲染深度的摄像机
    RenderTexture   depthTexture;  // 与Screen等大的深度缓存
    public void Awake()
    {
        // Create the depth texture with screen's size.
        depthTexture = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);

        // Create the depth camera.
        var deapthCameraGo = new GameObject("Depth Camera");
        //shadowCameraGO.hideFlags = HideFlags.DontSave | HideFlags.NotEditable | HideFlags.HideInHierarchy;
        depthCamera = deapthCameraGo.AddComponent<Camera>();
        depthCamera.CopyFrom(mainCamera);
        depthCamera.depth = -100;
        depthCamera.depthTextureMode = DepthTextureMode.Depth;
        depthCamera.renderingPath = RenderingPath.Forward;
        depthCamera.clearFlags = CameraClearFlags.Color;
        depthCamera.depthTextureMode = DepthTextureMode.None;
        depthCamera.useOcclusionCulling = false;
        depthCamera.depth = -100;
        depthCamera.SetReplacementShader(depthShader, "RenderType");
        depthCamera.targetTexture = depthTexture;
        //depthShader.enabled = false;

        Renderer r = GetComponent<Renderer>();
        r.sharedMaterial.SetTexture("_DepthTex", depthTexture);

    }

    void OnPreRender()
    {
       
    }
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleTexture : MonoBehaviour
{
    public Shader shader;
    Camera shaderCamera;
    public RenderTexture renderTexture;
    public Material mat;


    void CreateScaleTexture()
    {
        renderTexture = RenderTexture.GetTemporary(1024, 768);
        shaderCamera = new GameObject("Scale Texture Camera", typeof(Camera)).GetComponent<Camera>();
        //shaderCamera.CopyFrom(Camera.main);
        shaderCamera.gameObject.SetActive(false);
        //shaderCamera.SetReplacementShader(shader, "RenderType");
        shaderCamera.targetTexture = renderTexture;
        shaderCamera.clearFlags = CameraClearFlags.SolidColor;
        shaderCamera.backgroundColor = Color.white;
        shaderCamera.transform.position = Vector3.zero;
        shaderCamera.transform.rotation = Quaternion.identity;
        shaderCamera.transform.localScale = Vector3.one;

        shaderCamera.cullingMask = 1 << 20;

        GameObject go = GameObject.CreatePrimitive(PrimitiveType.Quad);
        //go.transform.SetParent(shaderCamera.transform);
        go.transform.position = new Vector3(0, 0, 1);
        go.GetComponent<Renderer>().material = mat;
        go.layer = 20;
    }

    // Use this for initialization
    void Start()
    {
        CreateScaleTexture();
    }

    void OnWillRenderObject()
    {
        //Debug.Log("OnWillRenderObject");
        shaderCamera.Render();
        //shaderCamera.RenderWithShader(shader, "RenderType");
    }
    // Update is called once per frame
    void Update () {
		
	}
}

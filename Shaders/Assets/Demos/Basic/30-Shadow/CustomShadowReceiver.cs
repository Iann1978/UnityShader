using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomShadowReceiver : MonoBehaviour {

    public Transform light;
    public Transform caster;
    public Camera shadowCamera;
    public RenderTexture shadowTexture;
    public Shader casterShader;
	// Use this for initialization
	void Start ()
    {
        shadowTexture = new RenderTexture(1024, 1024, 24, RenderTextureFormat.RFloat);
        GameObject shadowCameraObj = new GameObject("ShadowCamera_" + light.name, typeof(Camera));
        shadowCameraObj.transform.position = caster.position;
        shadowCameraObj.transform.rotation = light.rotation;
        shadowCameraObj.transform.localScale = Vector3.one;
        shadowCameraObj.transform.Translate(Vector3.back * 2, Space.Self);
        shadowCameraObj.SetActive(false);
        shadowCamera = shadowCameraObj.GetComponent<Camera>();
        shadowCamera.farClipPlane = 5;
        shadowCamera.nearClipPlane = 1;
        shadowCamera.targetTexture = shadowTexture;
        shadowCamera.orthographic = true;
        shadowCamera.orthographicSize = 2;
        shadowCamera.targetDisplay = 2;
        

    }
    void OnWillRenderObject()
    {
        if (Camera.current == shadowCamera)
            return;

        shadowCamera.gameObject.transform.position = caster.position;
        shadowCamera.gameObject.transform.rotation = light.rotation;
        shadowCamera.gameObject.transform.localScale = Vector3.one;
        shadowCamera.gameObject.transform.Translate(Vector3.back * 2, Space.Self);


        //Debug.Log("OnWillRenderObject");
        shadowCamera.RenderWithShader(casterShader, "RenderType");

    }
    // Update is called once per frame
    void Update () {

        Matrix4x4 projMat = GL.GetGPUProjectionMatrix(shadowCamera.projectionMatrix, false);
        Matrix4x4 viewMat = shadowCamera.worldToCameraMatrix;
        Matrix4x4 _ProjMatrix = projMat * viewMat;

        Renderer[] rends = GetComponentsInChildren<Renderer>();
        foreach(Renderer r in rends)
        {
            r.material.SetMatrix("_ProjMatrix", _ProjMatrix);
            r.material.SetTexture("_ProjTexture", shadowTexture);
        }



    }
}

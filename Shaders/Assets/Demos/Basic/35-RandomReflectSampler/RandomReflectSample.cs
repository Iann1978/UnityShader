using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class RandomReflectSample : MonoBehaviour {

	public GameObject frameCameraGameobject;
	public Camera frameCamera;
	public RenderTexture buffer0;
    public RenderTexture buffer1;
    public Shader lastFrameShader;
	public Texture albedoTexture;
    public int index = 0;
	// Use this for initialization
	void Awake () {
		buffer0 = RenderTexture.GetTemporary(512,512);
        buffer1 = RenderTexture.GetTemporary(512, 512);

        frameCameraGameobject = new GameObject("Frame Camera", typeof(Camera));
		frameCamera = frameCameraGameobject.GetComponent<Camera>();
		frameCamera.CopyFrom(Camera.main);
		frameCamera.targetTexture = buffer0;
		//frameCamera.layer = 1 << 8;
		frameCamera.cullingMask = 1 << LayerMask.NameToLayer("Player");
		frameCamera.SetReplacementShader(lastFrameShader, "RenderType");
        frameCamera.clearFlags = CameraClearFlags.Color;
        frameCamera.backgroundColor = Color.black;
		//frameCamera.depth = -2;
		frameCameraGameobject.SetActive(false);
		GetComponent<Renderer>().material.SetTexture("_LastFrame", buffer0);

		
	}
	
	void Destroy() {
		//RenderTexture.ReleaseTemporary(lastFrameBuffer);
	}

	void OnWillRenderObject () {

		if (frameCamera == Camera.current)
        {
            Graphics.Blit(buffer0, buffer1);
            GetComponent<Renderer>().material.SetTexture("_LastFrame", buffer1);
            GetComponent<Renderer>().material.SetInt("_Index", index++);
            Debug.Log(Time.frameCount/Time.realtimeSinceStartup);
            return;
        }
		else
        {
            frameCamera.RenderWithShader(lastFrameShader, "RenderType");
            GetComponent<Renderer>().material.SetTexture("_LastFrame", buffer0);

        }
		
		
	}
}

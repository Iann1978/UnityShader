using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class MotionBlur : MonoBehaviour {

    public Shader blendShader;
    public Material blendMat;
    public float lerpParam = 0.5f;
    RenderTexture lastFrameBuffer;
	// Use this for initialization
	void Start () {
        blendMat = new Material(blendShader);
        lastFrameBuffer = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);

    }
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {

        //RenderTexture buffer1 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
        //RenderTexture buffer2 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
        
        //Graphics.Blit(lastFrameBuffer, buffer2);
        //Graphics.Blit(src, buffer1);        
        blendMat.SetTexture("_Albedo", src);
        blendMat.SetTexture("_Albedo1", lastFrameBuffer);
        blendMat.SetFloat("_LerpParam", lerpParam);
        Graphics.Blit(src, dest, blendMat);
        Graphics.Blit(dest, lastFrameBuffer);


        //RenderTexture.ReleaseTemporary(buffer1);
        //RenderTexture.ReleaseTemporary(buffer2);

    }
}

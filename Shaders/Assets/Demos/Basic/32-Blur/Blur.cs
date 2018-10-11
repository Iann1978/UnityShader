using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class Blur : MonoBehaviour {

    public Shader blurShader;
    public Material blurMat;
	// Use this for initialization
	void Start () {
        blurMat = new Material(blurShader);
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {

        RenderTexture buffer1 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
        RenderTexture buffer2 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0);
        blurMat.SetTexture("_Albedo", src);
        Graphics.Blit(src, buffer1, blurMat, 0);

        for (int i=0; i<50; i++ )
        {
            blurMat.SetTexture("_Albedo", buffer1);
            Graphics.Blit(buffer1, buffer2, blurMat, 1);

            blurMat.SetTexture("_Albedo", buffer2);
            Graphics.Blit(buffer2, buffer1, blurMat, 0);
        }

        blurMat.SetTexture("_Albedo", buffer1);
        Graphics.Blit(buffer1, dest, blurMat, 1);

        RenderTexture.ReleaseTemporary(buffer1);
        RenderTexture.ReleaseTemporary(buffer2);

    }
}

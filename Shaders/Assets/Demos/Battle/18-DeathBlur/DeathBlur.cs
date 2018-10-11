using UnityEngine;
using System.Collections;

public class DeathBlur : MonoBehaviour {


    public Material scaleMat;
    public Material blendMat;

    RenderTexture scaledTex;
    RenderTexture resultTex;
    bool first = true;

    //public RenderTexture[] scaleTexs;

    //public int count = 1;
    //public int cur = 0;


    void Start()
    {
        scaledTex = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        resultTex = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        blendMat.SetTexture("_BlendTex", scaledTex);
        first = true;
        //scaleTexs = new RenderTexture[count];
        //for (int i=0; i<count; i++)
        //{
        //    RenderTexture rt = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        //    scaleTexs[i] = rt;
        //}
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (first)
        {
            Graphics.Blit(src, scaledTex);
            first = false;
        }
        //Graphics.Blit(src, dst, scaleMat);
        //Graphics.Blit(src, dst, blendMat);
        Graphics.Blit(src, resultTex, blendMat);
        Graphics.Blit(resultTex, dst);
        Graphics.Blit(resultTex, scaledTex, scaleMat);
    }
}

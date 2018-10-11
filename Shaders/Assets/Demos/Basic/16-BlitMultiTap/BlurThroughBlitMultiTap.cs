using UnityEngine;
using System.Collections;

public class BlurThroughBlitMultiTap : MonoBehaviour {

    public Material blurMat;
	
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.BlitMultiTap(src, dst, blurMat, new Vector2(50, 0), new Vector2(-50,0));
        //Graphics.Blit(src, dst, blurMat);
    }
}

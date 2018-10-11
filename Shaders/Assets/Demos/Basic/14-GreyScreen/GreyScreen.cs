using UnityEngine;
using System.Collections;

public class GreyScreen : MonoBehaviour {

    public Material mat;

    public void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        src.wrapMode = TextureWrapMode.Repeat;
        Graphics.Blit(src, dst, mat);
    }
    
}

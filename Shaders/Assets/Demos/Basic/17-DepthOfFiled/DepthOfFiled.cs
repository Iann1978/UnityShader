using UnityEngine;
using System.Collections;

public class DepthOfFiled : MonoBehaviour {


    public Material depthBlendMat;
    public Material threePointBlendMat;
    public float focusDepth;
    public RenderTexture blurTex1;
    public RenderTexture blurTex2;
    public RenderTexture blurTex3;
    public RenderTexture blurTex4;
    public RenderTexture srcTex;

    public void Start()
    {
        blurTex1 = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        blurTex2 = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        blurTex3 = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        blurTex4 = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        srcTex = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGB32);
        Camera camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;
    }


    public void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, srcTex);
        Graphics.BlitMultiTap(src, blurTex1, threePointBlendMat, new Vector2(0, 0), new Vector2(0, 2), new Vector2(0, -2));
        Graphics.BlitMultiTap(blurTex1, blurTex2, threePointBlendMat, new Vector2(0, 0), new Vector2(0, 2), new Vector2(0, -2));
        Graphics.BlitMultiTap(blurTex2, blurTex3, threePointBlendMat, new Vector2(0, 0), new Vector2(2, 0), new Vector2(-2, 0));
        Graphics.BlitMultiTap(blurTex3, blurTex4, threePointBlendMat, new Vector2(0, 0), new Vector2(2, 0), new Vector2(-2, 0));
        depthBlendMat.SetTexture("_BlendTex", blurTex4);
        depthBlendMat.SetFloat("_FocusDepth", focusDepth);
        //Graphics.Blit(blurTex2, dst, depthBlendMat);
        Graphics.Blit(src, dst, depthBlendMat);
    }

}

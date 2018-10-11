using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public class HeroHaloCamera : MonoBehaviour {

    public GameObject heroHaloCameraGameObject;
    public Camera heroHaloCamera;

    public RenderTexture heroHaloTexture;
    public RenderTexture buffer0;
    public RenderTexture buffer1;


    public Shader simpleColorShader;
    public Shader blurShader;
    public Shader blendShader;
    public Material blurMat;
    public Material blendMat;

    public int blurSize = 0;
    public Color haloColor;


    void Awake()
    {
        RenderTexturePool.me.NewRenderTextures();
        heroHaloTexture = RenderTexturePool.me.screenSizedBuffer0;
        buffer0 = RenderTexturePool.me.screenSizedBuffer1;
        buffer1 = RenderTexturePool.me.screenSizedBuffer2;


        heroHaloCameraGameObject = new GameObject("Hero Halo Camera", typeof(Camera));
        heroHaloCamera = heroHaloCameraGameObject.GetComponent<Camera>();
        heroHaloCamera.transform.SetParent(Camera.main.transform);
        heroHaloCamera.CopyFrom(Camera.main);
        heroHaloCamera.targetTexture = heroHaloTexture;
        heroHaloCamera.clearFlags = CameraClearFlags.Color;
        heroHaloCamera.backgroundColor = Color.black;
        heroHaloCamera.cullingMask = 1 << LayerMask.NameToLayer("Player");
        //heroHaloCamera.SetReplacementShader(simpleColorShader, "RenderType");

        blurMat = new Material(blurShader);
        blendMat = new Material(blendShader);
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }

    void OnDestroy()
    {
        RenderTexturePool.me.DestroyRenderTextures();

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexturePool.me.RefreshRenderTextures();
        heroHaloTexture = RenderTexturePool.me.screenSizedBuffer0;
        buffer0 = RenderTexturePool.me.screenSizedBuffer1;
        buffer1 = RenderTexturePool.me.screenSizedBuffer2;
        heroHaloCamera.targetTexture = heroHaloTexture;

        Graphics.Blit(heroHaloTexture, buffer0);

        for (int i = 0; i < blurSize; i++)
        {
            blurMat.SetTexture("_Albedo", buffer0);
            Graphics.Blit(source, buffer1, blurMat, 0);

            blurMat.SetTexture("_Albedo", buffer1);
            Graphics.Blit(source, buffer0, blurMat, 1);
        }

        blendMat.SetColor("_HaloColor", haloColor);
        blendMat.SetTexture("_Albedo", buffer0);
        blendMat.SetTexture("_Alpha", heroHaloTexture);
        Graphics.Blit(buffer0, destination, blendMat);
    }


}

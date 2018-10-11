using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderTexturePool : Singleton<RenderTexturePool>
{
    public RenderTexture screenSizedBuffer0;
    public RenderTexture screenSizedBuffer1;
    public RenderTexture screenSizedBuffer2;
    public RenderTexture screenSizedBuffer3;
    public int width, height;

    public void NewRenderTextures()
    {
        RefreshRenderTextures();
    }

    public void RefreshRenderTextures()
    {
        if (width != Screen.width || height != Screen.height)
        {
            width = Screen.width;
            height = Screen.height;
            RenderTexture.ReleaseTemporary(screenSizedBuffer0);
            RenderTexture.ReleaseTemporary(screenSizedBuffer1);
            RenderTexture.ReleaseTemporary(screenSizedBuffer2);
            RenderTexture.ReleaseTemporary(screenSizedBuffer3);
            screenSizedBuffer0 = RenderTexture.GetTemporary(width, height);
            screenSizedBuffer1 = RenderTexture.GetTemporary(width, height);
            screenSizedBuffer2 = RenderTexture.GetTemporary(width, height);
            screenSizedBuffer3 = RenderTexture.GetTemporary(width, height);
        }

    }

    public void DestroyRenderTextures()
    {
        RenderTexture.ReleaseTemporary(screenSizedBuffer0);
        RenderTexture.ReleaseTemporary(screenSizedBuffer1);
        RenderTexture.ReleaseTemporary(screenSizedBuffer2);
        RenderTexture.ReleaseTemporary(screenSizedBuffer3);
    }


}

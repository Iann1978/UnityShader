// ****************************************************************************
//
// 文件名称(File Name):			#SCRIPTFULLNAME# 
//
// 功能描述(Description):		
//
// 作者(Author): 				Iann
//
// 日期(Create Date): 			#DATE#
//
// 修改记录(Revision History):	
//
// ****************************************************************************

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestOnRenderImage : MonoBehaviour
{
    public Material mat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        mat.SetTexture("_Albedo", source);        
        Graphics.Blit(source, destination, mat);

        //RenderTexturePool.me.RefreshRenderTextures();
        //heroHaloTexture = RenderTexturePool.me.screenSizedBuffer0;
        //buffer0 = RenderTexturePool.me.screenSizedBuffer1;
        //buffer1 = RenderTexturePool.me.screenSizedBuffer2;
        //heroHaloCamera.targetTexture = heroHaloTexture;

        //Graphics.Blit(heroHaloTexture, buffer0);

        //for (int i = 0; i < blurSize; i++)
        //{
        //    blurMat.SetTexture("_Albedo", buffer0);
        //    Graphics.Blit(source, buffer1, blurMat, 0);

        //    blurMat.SetTexture("_Albedo", buffer1);
        //    Graphics.Blit(source, buffer0, blurMat, 1);
        //}

        //blendMat.SetColor("_HaloColor", haloColor);
        //blendMat.SetTexture("_Albedo", buffer0);
        //blendMat.SetTexture("_Alpha", heroHaloTexture);
        //Graphics.Blit(buffer0, destination, blendMat);
    }
}

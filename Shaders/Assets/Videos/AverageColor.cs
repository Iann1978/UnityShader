using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AverageColor : MonoBehaviour {

    public Renderer target;
    public Texture targetTexture;
    public RenderTexture tempTexture0;
    public Texture2D tempTexture1;
    public Color averageColor = new Color();

    Texture GetTargetTexture()
    {
        return target.material.mainTexture;
    }

    private void Update()
    {

        targetTexture = GetTargetTexture();

        if (tempTexture0 == null)
        {
            tempTexture0 = RenderTexture.GetTemporary(256, 256);
        }

        if (tempTexture1 == null)
        {
            tempTexture1 = new Texture2D(256, 256);
        }


        Graphics.Blit(targetTexture, tempTexture0);
        RenderTexture.active = tempTexture0;
        tempTexture1.ReadPixels(new Rect(0, 0, 256, 256), 0, 0);
        tempTexture1.Apply();


        averageColor = Color.black;
        Color[] colors = tempTexture1.GetPixels();
        







    }



}

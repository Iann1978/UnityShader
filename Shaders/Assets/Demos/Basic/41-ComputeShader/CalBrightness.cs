using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CalBrightness : MonoBehaviour {

    public ComputeShader    shader;
    public Texture          sourceTexture;
    public RenderTexture    tempTexture0;
    public RenderTexture    tempTexture1;
    int kenelScaleTexture0;
    int kenelScaleTexture1;
    int kenelOutBrightness1;
    float[] averageColor;
    ComputeBuffer computeBuffer;
    private void Start()
    {
        GenTempTextures();
    }

    private void OnDestroy()
    {
        ReleaseTempTextures();
    }

    private void Update()
    {
        sourceTexture = GetSourceTexture();

        if (sourceTexture != null)
        {
            Calculate();
            SetColor();
        }
    }

    Texture GetSourceTexture()
    {
        return sourceTexture;
    }

    void GenTempTextures()
    {
        tempTexture0 = new RenderTexture(256, 256, 24);
        tempTexture0.enableRandomWrite = true;
        tempTexture0.Create();

        tempTexture1 = new RenderTexture(256, 256, 24);
        tempTexture1.enableRandomWrite = true;
        tempTexture1.Create();
        kenelScaleTexture0 = shader.FindKernel("CSScaleTexture0");
        shader.SetTexture(kenelScaleTexture0, "TempTexture0", tempTexture0);
        shader.SetTexture(kenelScaleTexture0, "TempTexture1", tempTexture1);

        kenelScaleTexture1 = shader.FindKernel("CSScaleTexture1");
        shader.SetTexture(kenelScaleTexture1, "TempTexture0", tempTexture0);
        shader.SetTexture(kenelScaleTexture1, "TempTexture1", tempTexture1);

        averageColor = new float[3];
        computeBuffer = new ComputeBuffer(3, 4);
        kenelOutBrightness1 = shader.FindKernel("CSOutBrightness1");
        shader.SetTexture(kenelOutBrightness1, "TempTexture0", tempTexture0);
        shader.SetTexture(kenelOutBrightness1, "TempTexture1", tempTexture1);
        shader.SetBuffer(kenelOutBrightness1, "Result", computeBuffer);
    }

    void ReleaseTempTextures()
    {
        tempTexture0.Release();
        tempTexture1.Release();
        computeBuffer.Dispose();
    }

    void ScaleLevel(int level)
    {
        int kenel = kenelScaleTexture0;
        if (level % 2 == 0) kenel = kenelScaleTexture1;
        int size = 1;
        while ((level--)!=0) size *= 2;
        shader.Dispatch(kenel, size, size, 1);
    }


    void OutBrightness1()
    {
        shader.Dispatch(kenelOutBrightness1, 1, 1, 1);
        computeBuffer.GetData(averageColor);
        Debug.Log("Outdata:" + averageColor[0] + "," + averageColor[1] + "," + averageColor[2]);
    }

    void SetColor()
    {
        GetComponent<Renderer>().material.color = new Color(averageColor[0], averageColor[1], averageColor[2]);
    }

    void Calculate()
    {   
        Graphics.Blit(sourceTexture, tempTexture1);
        int level = 8;
        while(level--!=0) ScaleLevel(level);
        OutBrightness1();
    }



    private void OnGUI()
    {

        if (GUILayout.Button("GenTempTextures"))
        {
            GenTempTextures();
        }

        if (GUILayout.Button("Scale 128"))
        {
            ScaleLevel(7);
        }

        if (GUILayout.Button("Scale 64"))
        {
            ScaleLevel(6);
        }

        if (GUILayout.Button("Scale 32"))
        {
            ScaleLevel(5);
        }

        if (GUILayout.Button("Scale 16"))
        {
            ScaleLevel(4);
        }

        if (GUILayout.Button("Scale 8"))
        {
            ScaleLevel(3);
        }

        if (GUILayout.Button("Scale 4"))
        {
            ScaleLevel(2);
        }

        if (GUILayout.Button("Scale 2"))
        {
            ScaleLevel(1);
        }

        if (GUILayout.Button("Scale 1"))
        {
            ScaleLevel(0);
        }

        if (GUILayout.Button("OutBrightness1"))
        {
            OutBrightness1();
        }

        if (GUILayout.Button("SetColor"))
        {
            SetColor();
        }

        if (GUILayout.Button("Calculate"))
        {
            Calculate();
        }
    }
}



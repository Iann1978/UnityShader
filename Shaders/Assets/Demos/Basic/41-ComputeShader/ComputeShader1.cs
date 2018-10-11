using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeShader1 : MonoBehaviour {

    public ComputeShader shader10;
    public ComputeShader shader11;
    public RenderTexture tex10;
    public RenderTexture tex11;

    void GenRenderTexture10()
    {
        int kernelHandle = shader10.FindKernel("CSMain");

        tex10 = new RenderTexture(256, 256, 24);
        tex10.enableRandomWrite = true;
        tex10.Create();

        shader10.SetTexture(kernelHandle, "Result", tex10);
        shader10.Dispatch(kernelHandle, 256 / 8, 256 / 8, 1);
    }

    void GenRenderTexture11()
    {
        int kernelHandle = shader11.FindKernel("CSMain");

        tex11 = new RenderTexture(128, 128, 24);
        tex11.enableRandomWrite = true;
        tex11.Create();

        shader11.SetTexture(kernelHandle, "Tex10", tex10);
        shader11.SetTexture(kernelHandle, "Tex11", tex11);
        shader11.Dispatch(kernelHandle, 128 / 8, 128 / 8, 1);
        
    }

    private void OnGUI()
    {
        if (GUILayout.Button("GenRenderTexture10"))
        {
            GenRenderTexture10();
        }

        if (GUILayout.Button("GenRenderTexture11"))
        {
            GenRenderTexture11();
        }
    }
}



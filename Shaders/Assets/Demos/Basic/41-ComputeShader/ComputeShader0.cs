using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeShader0 : MonoBehaviour {

    public ComputeShader shader;
    public RenderTexture tex;

    void RunShader()
    {
        int kernelHandle = shader.FindKernel("CSMain");

        tex = new RenderTexture(256, 256, 24);
        tex.enableRandomWrite = true;
        tex.Create();

        shader.SetTexture(kernelHandle, "Result", tex);
        shader.Dispatch(kernelHandle, 256 / 8, 256 / 8, 1);
    }

    private void OnGUI()
    {
        if (GUILayout.Button("RunShader"))
        {
            RunShader();
        }
    }
}



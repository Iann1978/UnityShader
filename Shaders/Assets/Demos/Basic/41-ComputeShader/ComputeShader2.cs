using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeShader2 : MonoBehaviour {

    public ComputeShader shader2;
    
    void ReadBuffer()
    {
        int kernelHandle = shader2.FindKernel("CSMain");
        float[] data = new float[1];
        ComputeBuffer computeBuffer = new ComputeBuffer(data.Length, 4);
        computeBuffer.SetData(data);
        shader2.SetBuffer(kernelHandle, "Result", computeBuffer);
        shader2.Dispatch(kernelHandle, 1, 1, 1);
        float[] outdata = new float[1];
        computeBuffer.GetData(outdata);
        computeBuffer.Dispose();
        Debug.Log("Outdata:" + outdata[0]);
    }

    private void OnGUI()
    {
        if (GUILayout.Button("ReadBuffer"))
        {
            ReadBuffer();
        }

  
    }
}



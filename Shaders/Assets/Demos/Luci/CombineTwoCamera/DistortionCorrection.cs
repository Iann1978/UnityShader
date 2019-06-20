using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class DistortionCorrection : MonoBehaviour
{
    public Material mat;
    Camera camera;
    MeshFilter meshFilter;
    CommandBuffer commandBuffer;
    CameraEvent cameraEvent = CameraEvent.AfterEverything;

    // Start is called before the first frame update
    void Start()
    {   
        camera = GetComponent<Camera>();
        meshFilter = GetComponent<MeshFilter>();

        commandBuffer = new CommandBuffer();
        int screenCopyID = Shader.PropertyToID("_ScreenSampler");
        commandBuffer.GetTemporaryRT(screenCopyID, 1920, 1080, 0, FilterMode.Bilinear);
        commandBuffer.Blit(BuiltinRenderTextureType.CurrentActive, screenCopyID);
        commandBuffer.ClearRenderTarget(true, true, Color.red);
        commandBuffer.DrawMesh(meshFilter.mesh, Matrix4x4.identity, mat);
        GetComponent<Camera>().AddCommandBuffer(cameraEvent, commandBuffer);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnDisable()
    {
        //return;
        camera.RemoveCommandBuffer(cameraEvent, commandBuffer);
        commandBuffer.Dispose();
    }


    //private void OnRenderImage(RenderTexture source, RenderTexture destination)
    //{
    //    Graphics.Blit(source, destination, mat);
    //}


}
    
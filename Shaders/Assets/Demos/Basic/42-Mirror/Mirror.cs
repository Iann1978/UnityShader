using UnityEngine;
using System.Collections;
using System.Collections.Generic;


class MirrorCameraData
{
    public Camera sourceCamera;
    public Camera mirrorCamera;
    public RenderTexture mirrorTexture;
}

[ExecuteInEditMode]
public class Mirror : MonoBehaviour {

    //Camera mirrorCamera;
    //RenderTexture mirrorTexture;

    Dictionary<Camera, MirrorCameraData> mirrorCameraDatas = new Dictionary<Camera, MirrorCameraData>();
    public int cullingMask = 0;
    [HideInInspector]
    public bool dirty = true;


    Vector3 MirrorPosition(Vector3 pos, Vector3 o, Vector3 n)
    {
        n = n.normalized;
        Vector3 v = pos - o;

        return o + v - 2 * Vector3.Dot(n, v) * n;
    }

    Vector3 MirrorDir(Vector3 dir, Vector3 n)
    {
        return dir - n * 2 * Vector3.Dot(dir, n);
    }

    void UpdateMirrorCameraPosition(Camera mirrorCamera, Camera sourceCamera, Transform mirrorTransform)
    {
        Vector3 mirrorPosition = MirrorPosition(sourceCamera.transform.position, mirrorTransform.position, mirrorTransform.forward);
        mirrorCamera.transform.position = mirrorPosition;
        Vector3 forward = MirrorDir(sourceCamera.transform.forward, mirrorTransform.forward); 
        Vector3 upwards = MirrorDir(sourceCamera.transform.up, mirrorTransform.forward);
        Quaternion rotation = Quaternion.LookRotation(forward, upwards);
        mirrorCamera.transform.rotation = rotation;
    }

    void UpdateMirrorCameraParameters(ref MirrorCameraData mirrorCameraData)
    {
        Camera mirrorCamera = mirrorCameraData.mirrorCamera;
        Camera sourceCamera = mirrorCameraData.sourceCamera;
        RenderTexture mirrorTexture = mirrorCameraData.mirrorTexture;
        if (dirty || (mirrorTexture != null && (mirrorTexture.width != sourceCamera.pixelWidth || mirrorTexture.height != sourceCamera.pixelHeight)))
        {
            mirrorCamera.targetTexture = null;
            if (mirrorTexture != null)
            {
                mirrorTexture.Release();
                mirrorTexture = null;
            }
            dirty = false;
        }

        if (mirrorTexture == null)
        {
            Debug.Log("new RenderTexture(sourceCamera.pixelWidth, sourceCamera.pixelHeight, 8)");
            mirrorTexture = new RenderTexture(sourceCamera.pixelWidth, sourceCamera.pixelHeight, 8);
            //mirrorTexture = new RenderTexture(512, 512, 8);
            mirrorTexture.useMipMap = true;
            mirrorCamera.CopyFrom(sourceCamera);
            mirrorCamera.targetDisplay = 1;
            mirrorCamera.targetTexture = mirrorTexture;
            mirrorCamera.cullingMask = cullingMask;
            mirrorCamera.backgroundColor = Color.black;
            mirrorCamera.clearFlags = CameraClearFlags.Color;
        }
        mirrorCameraData.mirrorTexture = mirrorTexture;
    }

    void UpdateMirrorObjectMaterial(MirrorCameraData mirrorCameraData)
    {
        Camera mirrorCamera = mirrorCameraData.mirrorCamera;
        RenderTexture mirrorTexture = mirrorCameraData.mirrorTexture;
        Renderer rd = GetComponent<Renderer>();
        rd.sharedMaterial.SetTexture("_MirrorTex", mirrorTexture);
        Matrix4x4 projMat = GL.GetGPUProjectionMatrix(mirrorCamera.projectionMatrix, false);
        rd.sharedMaterial.SetMatrix("_ProjMat", projMat);
        Matrix4x4 viewMat = mirrorCamera.worldToCameraMatrix;
        rd.sharedMaterial.SetMatrix("_ViewMat", viewMat);
    }
    
    MirrorCameraData GetMirrorCameraData(Camera sourceCamera)
    {
        if (mirrorCameraDatas.ContainsKey(sourceCamera))
        {
            return mirrorCameraDatas[sourceCamera];
        }

        var mirrorCameraMgr = GameObject.Find("Mirror Camera Manager");
        if (mirrorCameraMgr == null)
        {
            mirrorCameraMgr = new GameObject("Mirror Camera Manager");
            mirrorCameraMgr.transform.position = Vector3.zero;
            mirrorCameraMgr.transform.rotation = Quaternion.identity;
            mirrorCameraMgr.transform.localScale = Vector3.one;
        }

        string mirrorCameraName = "Mirror camera of " + Camera.current.name + " by " + name;
        GameObject goMirrorCamera = null;
        for (int i = 0; i < mirrorCameraMgr.transform.childCount; i++)
        {
            if (mirrorCameraMgr.transform.GetChild(i).name.CompareTo(mirrorCameraName) == 0)
            {
                goMirrorCamera = mirrorCameraMgr.transform.GetChild(i).gameObject;
                break;
            }
        }


        if (goMirrorCamera == null)
        {
            goMirrorCamera = new GameObject("Mirror camera of " + Camera.current.name + " by " + name, typeof(Camera));
            goMirrorCamera.hideFlags = HideFlags.DontSave;
            goMirrorCamera.tag = "MirrorCamera";
            goMirrorCamera.transform.parent = mirrorCameraMgr.transform;
        }
        goMirrorCamera.SetActive(false);

        MirrorCameraData mirrorData = new MirrorCameraData();
        mirrorData.sourceCamera = sourceCamera;
        mirrorData.mirrorCamera = goMirrorCamera.GetComponent<Camera>();
        mirrorCameraDatas.Add(sourceCamera, mirrorData);
        return mirrorData;
    }

    void UpdateMirrorTexture()
    {
        MirrorCameraData mirrorCameraData = GetMirrorCameraData(Camera.current);
        UpdateMirrorCameraParameters(ref mirrorCameraData);
        UpdateMirrorCameraPosition(mirrorCameraData.mirrorCamera, Camera.current, transform);
        mirrorCameraData.mirrorCamera.Render();
        UpdateMirrorObjectMaterial(mirrorCameraData);
    }

    public void OnWillRenderObject()
    {
        if (Camera.current == Camera.main)
        {
            UpdateMirrorTexture();
        }


        if (Camera.current.cameraType == CameraType.SceneView && Camera.current.tag.CompareTo("MirrorCamera") != 0)
        {
            UpdateMirrorTexture();
        }
    }
}

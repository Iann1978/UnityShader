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
public class Mirror : MonoBehaviour
{
    Dictionary<Camera, Camera> mirrorCameras = new Dictionary<Camera, Camera>();
    [HideInInspector]
    public int cullingMask = 0;
    public Transform mirrorTransform;
    [HideInInspector]
    public bool dirty = true;
    [HideInInspector]
    public Transform mirrorCameraRoot;


    private void Awake()
    {
        Debug.Log("Mirror.Awake");
        Renderer renderer = GetComponent<Renderer>();
        renderer.material = new Material(renderer.material);


    }


    private void OnEnable()
    {
        if (mirrorTransform == null)
            mirrorTransform = transform;

        mirrorCameraRoot = transform.Find("Mirror Camera's Root");
        if (mirrorCameraRoot == null)
        {
            mirrorCameraRoot = new GameObject("Mirror Camera's Root").transform;
            mirrorCameraRoot.transform.SetParent(transform);
            mirrorCameraRoot.transform.localScale = Vector3.one;
            mirrorCameraRoot.transform.localPosition = Vector3.zero;
            mirrorCameraRoot.transform.localRotation = Quaternion.identity;
            //mirrorCameraRoot.hideFlags = HideFlags.HideInHierarchy | HideFlags.HideInInspector;
        }
    }

    private void OnDisable()
    {
#if UNITY_EDITOR
        DestroyImmediate(mirrorCameraRoot.gameObject);
#else
        Destroy(mirrorCameraRoot.gameObject);
#endif
    }

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

    Camera GetMirrorCamera(Camera sourceCamera)
    {
        if (mirrorCameras.ContainsKey(sourceCamera))
        {
            Camera mirrorCamera = mirrorCameras[sourceCamera];
            if (mirrorCamera != null && mirrorCamera.gameObject != null &&
                mirrorCamera.GetComponent<MirrorCamera>() != null
                && mirrorCamera.GetComponent<MirrorCamera>().sourceCamera == sourceCamera)
            {
                return mirrorCameras[sourceCamera];
            }

            if (mirrorCamera != null)
            {


                Debug.Log("Mirror.GetMirrorCamera Destroy the mirror camera.");
                RenderTexture mirrorTexture = mirrorCamera.targetTexture;
                mirrorCamera.targetTexture = null;
                mirrorTexture.Release();

#if UNITY_EDITOR
                DestroyImmediate(mirrorCamera.gameObject);
#else
                Destroy(mirrorCamera.gameObject);
#endif
            }

            mirrorCameras.Remove(sourceCamera);
        }
            

        GameObject go = new GameObject("Mirror camera of " + sourceCamera.name, typeof(Camera), typeof(MirrorCamera));
        go.tag = "MirrorCamera";
        go.hideFlags = HideFlags.DontSave;
        go.SetActive(false);
        go.GetComponent<MirrorCamera>().sourceCamera = sourceCamera;
        go.transform.SetParent(mirrorCameraRoot);
        mirrorCameras.Add(sourceCamera, go.GetComponent<Camera>());
        return go.GetComponent<Camera>();
    }


    void UpdateMirrorCamerasTexture(Camera sourceCamera, ref Camera mirrorCamera)
    {
        if (mirrorCamera.targetTexture != null && (
            mirrorCamera.targetTexture.width != sourceCamera.pixelWidth || mirrorCamera.targetTexture.height != sourceCamera.pixelHeight))
        {
            RenderTexture.ReleaseTemporary(mirrorCamera.targetTexture);
            mirrorCamera.targetTexture = null;
        }

        if (mirrorCamera.targetTexture == null)
        {
            RenderTextureDescriptor textureDesc = new RenderTextureDescriptor(sourceCamera.pixelWidth, sourceCamera.pixelHeight);
            textureDesc.useMipMap = true;
            mirrorCamera.targetTexture = RenderTexture.GetTemporary(textureDesc);
        }
    }

    void UpdateMirrorCameraPosition(Camera sourceCamera, ref Camera mirrorCamera, Transform mirrorTransform)
    {
        Vector3 mirrorPosition = MirrorPosition(sourceCamera.transform.position, mirrorTransform.position, mirrorTransform.forward);
        mirrorCamera.transform.position = mirrorPosition;
        Vector3 forward = MirrorDir(sourceCamera.transform.forward, mirrorTransform.forward);
        Vector3 upwards = MirrorDir(sourceCamera.transform.up, mirrorTransform.forward);
        Quaternion rotation = Quaternion.LookRotation(forward, upwards);
        mirrorCamera.transform.rotation = rotation;
    }

    void UpdateMirrorCamerasParameters(Camera sourceCamera, ref Camera mirrorCamera, RenderTexture mirrorTexture)
    {
        mirrorCamera.CopyFrom(sourceCamera);
        //mirrorCamera.targetDisplay = 1;
        mirrorCamera.targetTexture = mirrorTexture;
        mirrorCamera.cullingMask = cullingMask;
        mirrorCamera.backgroundColor = Color.black;
        mirrorCamera.clearFlags = CameraClearFlags.Color;
        mirrorCamera.useOcclusionCulling = false;
    }

    void UpdateMaterial(Camera mirrorCamera, RenderTexture mirrorTexture)
    {
        Renderer rd = GetComponent<Renderer>();
        rd.sharedMaterial.SetTexture("_MirrorTex", mirrorTexture);
        Matrix4x4 projMat = GL.GetGPUProjectionMatrix(mirrorCamera.projectionMatrix, false);
        rd.sharedMaterial.SetMatrix("_ProjMat", projMat);
        Matrix4x4 viewMat = mirrorCamera.worldToCameraMatrix;
        rd.sharedMaterial.SetMatrix("_ViewMat", viewMat);
    }


    void UpdateCamera(Camera sourceCamera)
    {
        GetComponent<Renderer>().sharedMaterial.SetTexture("_MirrorTex", null);
        Camera mirrorCamera = GetMirrorCamera(sourceCamera);
        UpdateMirrorCamerasTexture(sourceCamera, ref mirrorCamera);
        RenderTexture mirrorTexture = mirrorCamera.targetTexture;
        UpdateMirrorCamerasParameters(sourceCamera, ref mirrorCamera, mirrorTexture);
        UpdateMirrorCameraPosition(sourceCamera, ref mirrorCamera, mirrorTransform);
        mirrorCamera.Render();
        UpdateMaterial(mirrorCamera, mirrorTexture);
    }

    public void OnWillRenderObject()
    {
        if (Camera.current == Camera.main)
        {
            UpdateCamera(Camera.current);
        }


        if (Camera.current.cameraType == CameraType.SceneView && Camera.current.tag.CompareTo("MirrorCamera") != 0)
        {
            UpdateCamera(Camera.current);
        }

        //ClearInvalideCameras();
    }

    void DestroyMirrorCamera(Camera mirrorCamera)
    {
        Debug.Log("Mirror.GetMirrorCamera Destroy the mirror camera.");
        RenderTexture mirrorTexture = mirrorCamera.targetTexture;
        mirrorCamera.targetTexture = null;
        mirrorTexture.Release();

#if UNITY_EDITOR
        DestroyImmediate(mirrorCamera.gameObject);
#else
        Destroy(mirrorCamera.gameObject);
#endif
    }
}

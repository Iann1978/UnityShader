using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
public class CalOverDrawValue : MonoBehaviour {
    

    //RenderTexture overdrawRenderTexture;    
    //Camera overdrawCamera;
    long total = 0;
    long totalPixels = 0;
    double overdraw = 0;

	// Use this for initialization
	void Start () {
        total = 0;
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    public void Awake()
    {
        //overdrawRenderTexture = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.R8);
        //var overdrawCameraGo = new GameObject("Overdraw Camera(Copy of " + name + ")");
        //// Create the depth camera.
        ////shadowCameraGO.hideFlags = HideFlags.DontSave | HideFlags.NotEditable | HideFlags.HideInHierarchy;
        //overdrawCamera = overdrawCameraGo.AddComponent<Camera>();
        //overdrawCamera.CopyFrom(GetComponent<Camera>());
        //overdrawCamera.depth = -100;
        //overdrawCamera.depthTextureMode = DepthTextureMode.None;
        //overdrawCamera.renderingPath = RenderingPath.Forward;
        //overdrawCamera.clearFlags = CameraClearFlags.Color;
        //overdrawCamera.depthTextureMode = DepthTextureMode.None;
        //overdrawCamera.useOcclusionCulling = false;
        //overdrawCamera.depth = -100;
        ////overdrawCamera.SetReplacementShader(depthShader, "RenderType");
        //overdrawCamera.targetTexture = overdrawRenderTexture;


    }
    void OnGUI()
    {
        GUI.Label(new Rect(0, 0, 300, 50), "total:" + total.ToString());
        GUI.Label(new Rect(0, 50, 300, 50), "totalPixels:" + totalPixels.ToString());
        GUI.Label(new Rect(0, 100, 300, 50), "overdraw:" + overdraw.ToString());

        //if (GUI.Button(new Rect(0,0,100,100), "Total"))
        //{
        //    total = Total(overdrawRenderTexture );
        //}
    }

    void OnPostRender()
    {
        Texture2D tex = new Texture2D(Screen.width, Screen.height);
        tex.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0);
        tex.Apply();
        total = 0;
        for (int x = 0; x < tex.width; x++)
        {
            for (int y = 0; y < tex.height; y++)
            {
                Color c = tex.GetPixel(x, y);
                total += (long)(c.r * 5);
            }
        }
        overdraw = (double)(total) / (double)(Screen.width * Screen.height);
    }

   
}

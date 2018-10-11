using UnityEngine;
using System.Collections;

public class RenderWith : MonoBehaviour {

    public Shader redShader;
    public Shader blueShader;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnGUI()
    {
        if (GUI.Button(new Rect(0,0,100,100), "Red"))
        {
            Camera camera = GetComponent<Camera>();
            camera.SetReplacementShader(redShader, "RenderType");
        }
    }
}

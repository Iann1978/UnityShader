using UnityEngine;
using System.Collections;


public class SwingForMotionBlur : MonoBehaviour {

    public float y, z;
    public float dis = 2.0f;
	// Use this for initialization
	void Start () {
        y = transform.position.y;
        z = transform.position.z;
	}
	
	// Update is called once per frame
	void Update () 
    {
        transform.position = new Vector3(dis * Mathf.Sin(Time.time), y, z);
	}
}

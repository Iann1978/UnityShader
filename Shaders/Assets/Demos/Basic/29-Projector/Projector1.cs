using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[ExecuteInEditMode] 
public class Projector1 : MonoBehaviour {

    public Transform proj;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Matrix4x4 projMat = Matrix4x4.identity;
        projMat.m22 = 0;
        projMat.m33 = 0;
        projMat.m32 = 1;

        projMat = projMat * proj.worldToLocalMatrix;

        GetComponent<Renderer>().material.SetMatrix("_ProjMatrix", projMat);		
	}
}

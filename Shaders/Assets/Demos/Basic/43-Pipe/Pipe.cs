using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(Renderer))]
public class Pipe : MonoBehaviour {

    public float width = 1.0f;
    public float height = 1.0f;

    private void Awake()
    {

    }

    [ContextMenu("GeneratePipeMesh")]
    void GeneratePipeMesh()
    {
        var meshFilter = gameObject.GetComponent<MeshFilter>();



        Vector3[] points = new Vector3[2];
        points[0] = Vector3.zero;
        points[1] = Vector3.right;


        int[] indices = new int[points.Length];
        for (int i = 0; i < indices.Length; i++)
        {
            indices[i] = i;
        }
        Mesh mesh = new Mesh();
        mesh.vertices = points;
        mesh.SetIndices(indices, MeshTopology.Lines, 0);


        meshFilter.mesh = mesh;

    }
    // Use this for initialization
    void Start ()
    {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}

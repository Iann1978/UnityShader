using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleMirror : MonoBehaviour {
    public Shader shader;

	// Use this for initialization
	void Start () {
        ParticleSystem[] pss = GetComponentsInChildren<ParticleSystem>();
        foreach (ParticleSystem ps in pss)
        {
            Renderer[] rs = ps.GetComponentsInChildren<Renderer>();
            foreach(Renderer r in rs)
            {
                Material mat = new Material(r.material);
                mat.shader = shader;
                mat.SetVector("_MirrorPosition", transform.position);
                r.material = mat;
            }
        }
        

		
	}
	
	// Update is called once per frame
	void Update () {
        ParticleSystem[] pss = GetComponentsInChildren<ParticleSystem>();
        foreach (ParticleSystem ps in pss)
        {
            Renderer[] rs = ps.GetComponentsInChildren<Renderer>();
            foreach (Renderer r in rs)
            {
                r.material.SetVector("_MirrorPosition", transform.position);
            }
        }

    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeroHalo : MonoBehaviour {
    public Color haloColor;
    public Shader simpleColorShader;
    public Material simpleColorMat;
    public Material originalMat;
    Renderer renderer;
    //public bool recursive = false;


    private void Awake()
    {
        simpleColorShader = Shader.Find("Iann/Hero/Halo/SimpleColor");
        renderer = GetComponent<Renderer>();
        originalMat = renderer.material;
        simpleColorMat = new Material(simpleColorShader);
        
    }



    void OnWillRenderObject()
    {
        
        if (Camera.current.name == "Hero Halo Camera")
        {
            renderer.material = simpleColorMat;
            if (gameObject.layer == LayerMask.NameToLayer("Player"))
            {
                simpleColorMat.SetColor("_Color", Color.white);
            }
            else
            {
                simpleColorMat.SetColor("_Color", Color.black);
            }
            //gameObject.layer = LayerMask.NameToLayer("Player");
            //gameObject.layer = LayerMask.NameToLayer("Player");

        }
        else
        {
            renderer.material = originalMat;
           // gameObject.layer = 1 << LayerMask.NameToLayer("Default");
        }
    }
}

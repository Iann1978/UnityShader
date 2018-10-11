
using UnityEngine;
using UnityEngine.UI;
[RequireComponent(typeof(RawImage))]
public class UIRollingImage : MonoBehaviour {

    public Vector2 rollingSpeed = new Vector2(1.0f, 0.0f);
    RawImage rawIamge;
	// Use this for initialization
	void Start () {
        rawIamge = GetComponent<RawImage>();
        rawIamge.material.SetVector("_RollingSpeed", new Vector4(rollingSpeed.x, rollingSpeed.y, 0, 0));


    }
	
	// Update is called once per frame
	void Update () {
		
	}
}

﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {
    public float speed = 1.0f;

	
	// Update is called once per frame
	void Update () {
        transform.Rotate(Vector3.up, Time.deltaTime * speed);
		
	}
}

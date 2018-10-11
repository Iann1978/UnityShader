using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SimpleCameraController : MonoBehaviour {

    /// <summary>
    /// Rotation Speed 
    /// </summary>
    float rotateSpeed = 10f;

    // Update is called once per frame
    void Update () {
        if (Input.GetKey("a"))
        {
            transform.Rotate(0, -1 * rotateSpeed * Time.deltaTime, 0);
        }
        else if (Input.GetKey("d"))
        {
            transform.Rotate(0, 1 * rotateSpeed * Time.deltaTime, 0);
        }
        else if (Input.GetKey("w"))
        {
            transform.Rotate(-1 * rotateSpeed * Time.deltaTime, 0, 0);
        }
        else if (Input.GetKey("s"))
        {
            transform.Rotate(1 * rotateSpeed * Time.deltaTime, 0, 0);
        }
        else if (Input.GetKey("q"))
        {
            transform.Rotate(0, 0, -1 * rotateSpeed * Time.deltaTime);
        }
        else if (Input.GetKey("e"))
        {
            transform.Rotate(0, 0, 1 * rotateSpeed * Time.deltaTime);
        }
    }
}

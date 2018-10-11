using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorCamera : MonoBehaviour
{
    public Transform mirrorTransform;
    public Camera sourceCamera;
    public Camera mirrorCamera;
    public RenderTexture mirrorTexture;
}

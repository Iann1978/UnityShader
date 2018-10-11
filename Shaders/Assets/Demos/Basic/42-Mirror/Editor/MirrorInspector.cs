using UnityEngine;
using UnityEditor;


[CustomEditor(typeof(Mirror))]

public class MirrorInspector : Editor {


    public override void OnInspectorGUI()
    {
        //base.OnHeaderGUI();
        Mirror mirror = (Mirror)target;

        string[] layerOptions = new string[32];
        for (int i = 0; i < 32; i++)
        {
            layerOptions[i] = LayerMask.LayerToName(i);
        }
        mirror.cullingMask = EditorGUILayout.MaskField("Culling Mask", mirror.cullingMask, layerOptions);

    }

}

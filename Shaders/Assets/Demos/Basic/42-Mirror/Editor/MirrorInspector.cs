using UnityEngine;
using UnityEditor;


[CustomEditor(typeof(Mirror))]

public class MirrorInspector : Editor {

    SerializedProperty cullingMask;

    void OnEnable()
    {
        // Setup the SerializedProperties.
        cullingMask = serializedObject.FindProperty("cullingMask");
    }
    public override void OnInspectorGUI()
    {

        serializedObject.Update();

        //base.OnHeaderGUI();
        Mirror mirror = (Mirror)target;

        
        string[] layerOptions = new string[32];
        for (int i = 0; i < 32; i++)
        {
            layerOptions[i] = LayerMask.LayerToName(i);
        }

        int oldCullingMaskValue = cullingMask.intValue;

        int newCullingMaskValue = EditorGUILayout.MaskField("Culling Mask", oldCullingMaskValue, layerOptions);



        cullingMask.intValue = newCullingMaskValue;

        serializedObject.ApplyModifiedProperties();

        if (oldCullingMaskValue != newCullingMaskValue)
        {
            mirror.dirty = true;
        }

    }

}

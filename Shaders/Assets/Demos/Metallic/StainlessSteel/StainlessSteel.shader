shader "Iann/Metal/StainlessSteel" {
	Properties {
		_Diffuse("Diffuse", Range(0,1)) = 0.2
		_Specular("Specular", Range(0,1)) = 1.0
		_Gloss("Gloss", Range(0,1)) = 0.5
		_AnisoX("Aniso X", Range(0,1)) = 1
		_AnisoY("Aniso Y", Range(0,1)) = 1
		_AnisoAngle("Aniso Angle", Range(0,180)) = 0
		_AnisoIntensity("Aniso Intensity", Range(0, 1)) = 0
		_AnisoTexture("Aniso Texture", 2D) = "blue"{}
	}

	SubShader {
		Name "Normal"
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }

			Blend One Zero

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "StainlessSteel.cginc"
			ENDCG

		}




		Pass {
			Name "Forward Add"
			Tags { "LightMode" = "ForwardAdd" }

			Blend One One

			CGPROGRAM
			#pragma target 2.0
			#pragma multi_compile_fwdadd

			#pragma vertex vert
			#pragma fragment frag
			//#define POINT
			#define UNITY_PASS_FORWARDADD
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "StainlessSteel.cginc"

			ENDCG

		}
	}

	Fallback "VertexLit"

}
shader "Iann/Basic/UseInternalShadowMap" {
	Properties {

	}

	SubShader { 
		Name "Lod300"
		LOD 300
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
		Pass {
			Name "ForwardBase"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma target 3.0
			


			#pragma multi_compile_fwdbase // if you want to use shadow map , you must write this
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE 
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc" 
			

			struct v2f { 
				float4 pos : SV_POSITION;
				SHADOW_COORDS(1)
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				TRANSFER_SHADOW(o);
			}

			void frag(in v2f v, out float4 c : COLOR) {
				half atten = SHADOW_ATTENUATION(v);
				c = atten;
			}
			ENDCG
		}

		// Note : if you want to use shadow map , you must implement the pass with
		// ShadowCaster tag

		Pass {
			Name "Shadow Caster"
			Tags { "LightMode" = "ShadowCaster" }
			Blend One Zero

			CGPROGRAM
			#pragma target 3.0
			

			//#pragma multi_compile_shadowcaster
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc" 
			

			struct v2f { 
				float4 pos : SV_POSITION;
			};

			// Note : unity use the function when receive the shadow. we don't know how the unity use this function.
			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
			}

			void frag(in v2f v, out float4 c : COLOR) {
				c = 0;
			}
			ENDCG
		}
	}
	//Fallback "VertexLit"
}
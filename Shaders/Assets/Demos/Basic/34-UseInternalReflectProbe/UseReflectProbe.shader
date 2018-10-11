shader "Iann/Basic/UserReflectProbe" {
	Properties {

	}

	SubShader {
		Name "LOD 300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		
		Pass {
			Name "ForwardBase"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 vertex : TEXCOORD3;
			};

			void vert(in appdata_base input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				output.normal = input.normal;
				output.vertex = input.vertex;
			}

			void frag(in v2f input, out float4 c : COLOR) {
				float3 n = normalize(UnityObjectToWorldNormal(input.normal));
				float3 v = normalize(WorldSpaceViewDir(input.vertex));
				float3 r = reflect(-v,n);
				c = unity_SpecCube0.SampleLevel (samplerunity_SpecCube0,r, 0);

				//c = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, r, 0);
				//c = 0;
				//c = texCUBE(unity_SpecCube0, input.normal);
			}
			ENDCG
		}
	}
}
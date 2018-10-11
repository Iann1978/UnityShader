// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

shader "Iann/Basic/UseLightMap" {
	Properties {

	}

	SubShader {
		Name "LOD300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#define UNITY_PASS_FORWARD
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			void vert(in appdata input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				output.texcoord = input.texcoord;
				output.texcoord1 = input.texcoord1;
			}

			void frag(in v2f input, out float4 c : COLOR) {
				c.rgb = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, input.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw));
				c.a = 1;
			}
			ENDCG
		}
	}
}
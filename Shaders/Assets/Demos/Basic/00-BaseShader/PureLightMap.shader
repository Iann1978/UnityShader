// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Pure LightMap

shader "My/Basic/PureLightmap"
{
	Properties
	{

	}

	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
			}

			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv1 : TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv1 : TEXCOORD1;
			};

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv1 = input.uv1;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float2 uv = input.uv1 * unity_LightmapST.xy + unity_LightmapST.zw;
				c.rgb = UNITY_SAMPLE_TEX2D(unity_Lightmap, uv).rgb;
				c.a = 1;
				//c.r = unity_LightmapST.x;
				//c.g = unity_LightmapST.y;
				//c.b = 0;
			}
			ENDCG

		}
		
	}


}
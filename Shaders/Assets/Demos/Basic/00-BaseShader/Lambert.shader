// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Lit Larbert

shader "My/Basic/Lambert"
{
	Properties
	{
		_BaseTexture("Base Texture", 2D) = "white"{}
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "Vertex"
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
			}

			Blend One Zero
			ZWrite On
			//ZTest On
			//Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _BaseTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 color : COLOR;
				float4 uv : TEXCOORD0; 
				float4 normal : NORMAL;
			};

			void vert(in appdata input, out v2f output)
			{
				// positioin
				output.pos = UnityObjectToClipPos(input.vertex);

				// uv
				output.uv = input.uv;

				output.normal = input.normal;

				// light color
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal.xyz);
				float3 lightColor = _LightColor0.xyz;

				float NdotL = max(0.0f,dot(normalDir, lightDir));				
				output.color.rgb = lightColor * NdotL;
				output.color.a = 1.0f;
			}

			void frag(in v2f input, out float4 color : COLOR)
			{
				// light color
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal.xyz);
				float3 lightColor = _LightColor0.xyz;

				float NdotL = max(0.0f, dot(normalDir, lightDir));
				color.rgb = lightColor * NdotL;
				color.a = 1.0f;


				//float4 baseColor = tex2D(_BaseTexture, input.uv.xy);
				//color = input.color * baseColor;
				

			}
			ENDCG


		}
	}
}
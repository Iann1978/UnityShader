// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Lambert With Normal

shader "My/Basic/LambertWithNormal"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_NormalTex("Normal Texture", 2D) = "bump" {}
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

			//Blend One Zero
			//ZTest Less
			//ZWrite On
			//Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _BaseColor;
			sampler2D _NormalTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
				float4 tangent : TARGENT;
			};

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.uv;
				output.normal = input.normal;
				output.tangent = input.tangent;
			}


			void frag(in v2f input, out float4 c : COLOR)
			{

				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 tangentDir = UnityObjectToWorldNormal(input.tangent);
				float3 binormalDir = normalize(cross(normalDir, tangentDir)* input.tangent.w);
				float3 normalDirInTargent = UnpackNormal(tex2D(_NormalTex, input.uv));
				float3 normal = normalDirInTargent.x * tangentDir + normalDirInTargent.y * binormalDir  + normalDirInTargent.z * normalDir;
				//normal = 1 * tangentDir + normalDirInTargent.z * normalDir;
				float NdotL = max(0.0f, dot(normal, lightDir));
				float3 lightColor = _LightColor0.xyz;
				c.rgb = lightColor * NdotL;
				//c.rgb = normalDirInTargent;
				//c.rgb = normalDirInTargent;
				c.a = 1.0f;
			}

			ENDCG
		}
	}
}
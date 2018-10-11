// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// PlinngPhoneWithNormal

shader "My/Basic/PlinngPhoneWithNormal"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "blue" {}
		_Specular("Specular", Float) = 128
		_Gloss("Gloss", Range(0,1)) = 0.5
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

			//Cull Back
			//ZWrite On
			//ZTest Less
			//Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _Albedo;
			sampler2D _Normal;
			float _Specular;
			float _Gloss;


			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float3 position : TEXCOORD1;
			};

			void vert(in appdata_tan input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord.xy;
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.position = input.vertex;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 tangentDir = UnityObjectToWorldNormal(input.tangent.xyz);
				float3 bitangentDir = cross(tangentDir, normalDir);
				float3 normalInTangentScpace = UnpackNormal(tex2D(_Normal, input.uv));
				float3 normal = normalInTangentScpace.x * tangentDir + normalInTangentScpace.y * bitangentDir + normalInTangentScpace.z * normalDir;
				float3 baseColor = tex2D(_Albedo, input.uv).xyz;
				float3 eyePos = _WorldSpaceCameraPos.xyz;
				float3 vertPos = mul(unity_ObjectToWorld, float4(input.position,1)).xyz;
				float3 eyeDir = normalize(eyePos - vertPos);
				float3 h = normalize(lightDir + eyeDir);
				float3 NdotL = saturate(dot(normal, lightDir));
				float3 NdotH = saturate(dot(normal, h));
				float3 lightColor = _LightColor0.xyz;
				float3 diffuse = baseColor * lightColor * NdotL;
				float3 specular = lightColor * pow(NdotH, _Specular) * _Gloss;
				c.rgb = diffuse + specular;
				c.a = 1;
			}
			ENDCG
		}
	}
}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Light Box

shader "My/LightBox"
{
	Properties
	{
		_LitPos("Light Position", Vector) = (0,0,0,1)
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

			float3 _LitPos;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 position : TEXCOORD0;
			};

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.position = input.vertex;
				output.position /= output.position.w;
				output.normal = input.normal;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float3 worldNormal = UnityObjectToWorldNormal(input.normal);
				float4 worldPos = mul(unity_ObjectToWorld, input.position);
				worldPos /= worldPos.w;
				float3 lightDir = normalize(_LitPos - worldPos);
				float3 refractDir = refract(-lightDir, -worldNormal, 1.1);
				float3 eyePos = _WorldSpaceCameraPos.xyz;
				float3 eyeDir = normalize(eyePos - worldPos.xyz);
				float RdotV = dot(refractDir, eyeDir);
				c.rgb = pow(RdotV,10);
				//c.b = 0;
				c.a = 1;
			}

			ENDCG
		}
	}
}
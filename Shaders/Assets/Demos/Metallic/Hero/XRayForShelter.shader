// Character's XRay for Shelter

shader "My/Character/XRayForShelter"
{

	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "blue" {}
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Geometry+600"
			"RenderType" = "Opaque"
		}

		Pass
		{
			Name "XRay For Shelter"
			Tags
			{
				"LightMode" = "ForwardBase"
			}

			Blend SrcAlpha OneMinusSrcAlpha
			ZTest Always
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _Albedo;
			sampler2D _Normal;
			sampler2D _CameraDepthTexture;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			void vert(in appdata_tan input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.pos /= output.pos.w;
				output.worldPos = mul(unity_ObjectToWorld, input.vertex);
				output.worldPos /= output.worldPos.w;
				output.uv = input.texcoord;
				output.normal = input.normal;
				output.tangent = input.tangent;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float2 suv = float2(input.pos.x / _ScreenParams.x, input.pos.y / _ScreenParams.y);
				suv.y = 1 - suv.y;
				float z = Linear01Depth(input.pos.z);
				float z1 = Linear01Depth(tex2D(_CameraDepthTexture, suv));
				//float z = input.pos.z;
				//float z1 = tex2D(_CameraDepthTexture, suv);
				float3 normalDir = normalize(UnityObjectToWorldNormal(input.normal));
				float3 tangentDir = normalize(UnityObjectToWorldNormal(input.tangent.xyz));
				float3 binormalDir = cross(tangentDir, normalDir);
				float3 normalInTangent = UnpackNormal(tex2D(_Normal,input.uv));
				float3 normal = normalInTangent.x * tangentDir + normalInTangent.y * binormalDir + normalInTangent.z * normalDir;
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.worldPos);
				float NdotV = max(0.0, dot(normal, viewDir));
				float xIntencity = 1 - NdotV;
				if (z<z1+0.001) discard;
				c.r = 0;
				c.rgb = xIntencity;
				//c.gb = 0;
				c.a = 1;
			}
			ENDCG
		}
	}

}

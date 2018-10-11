// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader

shader "Iann/Basic/Pipe"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
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

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			uniform float4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.texcoord = input.texcoord;
				output.normal = input.normal;
				output.tangent = input.tangent;
				//output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c:Color)
			{
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 tangentDir = UnityObjectToWorldNormal(input.tangent);
				float3 binormalDir = normalize(cross(normalDir, tangentDir)* input.tangent.w);
				
				float y = input.texcoord.y;
				y = (y-0.5)*2;
				float x = sqrt(1-y*y);
				float3 normal = x*normalDir + y*tangentDir;


				float3 NdotL = saturate(dot(normal, lightDir));
				float3 baseColor = _Color;
				float3 lightColor = _LightColor0.xyz;
				float3 diffuse = baseColor * lightColor * NdotL;

				c.rgb = diffuse;
				//c = float4(0,1,1,1);
			}
			ENDCG
		}
	}
}
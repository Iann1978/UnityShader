#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced '_WorldSpaceCameraPos.w' with '1.0'

Shader "My/Anisotropic2"
{
	Properties
	{
		_Albedo("Albedo", Color) = (1,1,1,0)
		_SpecularT("SpecularT", Float) = 20
		_SpecularB("SpecularB", Float) = 20
		_GlossT("GlossT", Range(0,1)) = 1
		_GlossB("GlossB", Range(0,1)) = 1
		_AnisoTexture("Aniso Texture", 2D) = "blue"{}
		_AnisoOffset("Aniso Offset", Float) = 1
	}

	SubShader
	{
		Name "Normal SubShader"

		Tags
		{
			"Queue" = "Geometry"
		}
		


		Pass 
		{
			Name "Forward Add"
			Tags
			{
				"LightMode" = "ForwardBase"
				"RenderType" = "Transparent"
			}

			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Albedo;
			float _SpecularT,_SpecularB;
			float _GlossT,_GlossB;
			sampler2D _AnisoTexture;
			float _AnisoOffset;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 vertex : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord : TEXCOORD1;

			};

			void vert (in appdata_tan input, out v2f output)
			{
				output.vertex = input.vertex;
				output.pos = UnityObjectToClipPos(input.vertex);
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.texcoord = input.texcoord;
			}

			void frag (in v2f input, out float4 c : COLOR)
			{
				float3 lightColor = unity_LightColor[0].rgb;
				float3 eyePos = _WorldSpaceCameraPos.xyz;
				float4 vertPos = mul(unity_ObjectToWorld, input.vertex);
				vertPos = vertPos / vertPos.w;
				float3 lightPos = float3(unity_4LightPosX0[0], unity_4LightPosY0[0], unity_4LightPosZ0[0]);
				float3 n = normalize(UnityObjectToWorldNormal(input.normal));
				float3 l = normalize(lightPos - vertPos.xyz);
				float3 v = normalize(eyePos - vertPos.xyz);
				float3 h = normalize(l+v);
				
				float NdotL = saturate(dot(n,l));
				float3 diffuse = NdotL * _Albedo * lightColor;

				float3 normalDir = normalize(UnityObjectToWorldNormal(input.normal));
				float3 tangentDir = normalize(UnityObjectToWorldNormal(input.tangent.xyz));
				float3 bitangentDir = cross(tangentDir, normalDir);

				float3 anisoInTangent = normalize(UnpackNormal(tex2D(_AnisoTexture,input.texcoord)));
				

				float HdotT = dot(h, float3(0,1,0));
				float HdotB = dot(h, float3(0,0,1));
				float NdotH_T = sqrt(1-HdotT*HdotT);
				float NdotH_B = sqrt(1-HdotB*HdotB);
				float HdotN = saturate(dot(n,h));
				//HdotN = saturate(dot(h, float3(1,0,0)));
				HdotN = sqrt(1-HdotT*HdotT-HdotB*HdotB);

				float3 specularT = lightColor * pow(NdotH_T, _SpecularT) * _GlossT;
				float3 specularB = lightColor * pow(NdotH_B, _SpecularB) * _GlossB;

				float3 specular = specularB + specularT ;

				c.rgb = diffuse + specular;
				//c.rgb = bitangentDir;
				c.a = 1;
			}

			ENDCG
		}




	}
}
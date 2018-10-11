#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced '_WorldSpaceCameraPos.w' with '1.0'

Shader "My/Anisotropic1"
{
	Properties
	{
		_Albedo("Albedo", Color) = (1,1,1,0)
		_Specular("Specular", Float) = 20
		_Gloss("Gloss", Float) = 1
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
			#pragma target 3.0
			
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Albedo;
			float _Specular;
			float _Gloss;
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

				float3 anisoDir = UnpackNormal(tex2D(_AnisoTexture, input.texcoord));
				float3 an = normalize(n + anisoDir);
				float AdotH = saturate(dot(an,h));
				float NdotH = saturate(dot(n,h));
				float aniso = saturate(sin(radians(AdotH+_AnisoOffset))*180);
				float3 specular = lightColor * pow(aniso, _Specular) * _Gloss;

				c.rgb = diffuse + specular;
				c.a = 1;
			}

			ENDCG
		}




	}
}
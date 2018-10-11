shader "My/Anisotropic/Ward"
{
	Properties
	{
		_Specular("Specular", Range(0,1)) = 1.0
		_Gloss("Gloss", Range(0,1)) = 0.5
		_AnisoX("Aniso X", Range(0,1)) = 1
		_AnisoY("Aniso Y", Range(0,1)) = 1
	}

	SubShader 
	{
		Name "Normal"
		Tags
		{
			"Queue" = "Geometry"
		}

		Pass
		{
			Name "Forward Base"
			Tags 
			{
				"LightMode" = "ForwardBase"
				"RenderType" = "Opaque"
			}

			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _Specular;
			float _Gloss;
			float _AnisoX, _AnisoY;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 worldPos : TEXCOORD0;
			};

			void vert(in appdata_tan input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.worldPos = mul(unity_ObjectToWorld, input.vertex);
				output.worldPos /= output.worldPos.w;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float3 lightColor = unity_LightColor[0].rgb;
				float3 vertPos = input.worldPos.xyz;
				float3 lightPos = float3(unity_4LightPosX0[0], unity_4LightPosY0[0], unity_4LightPosZ0[0]);
				float3 normalDir = normalize(UnityObjectToWorldNormal(input.normal));
				float3 tangentDir = normalize(UnityObjectToWorldNormal(input.tangent));
				float3 bitangentDir = normalize(cross(tangentDir, normalDir));
				float3 lightDir = lightPos - vertPos;
				float3 l = normalize(lightDir);
				float3 v = normalize(_WorldSpaceCameraPos.xyz - vertPos);
				float3 n = normalDir;
				float3 h = normalize(l+v);
				float3 t = tangentDir;
				float3 b = bitangentDir;
				float3 dotLN = saturate(dot(l,n));
				float3 dotHN = saturate(dot(h,n));
				float3 dotHT = (dot(h,t));
				float3 dotHB = (dot(h,b));
				float3 dotVN = saturate(dot(v,n));

				// attenuate
				float dis2 = dot(lightDir, lightDir);
				float lightRange = 10;
				float attenuate = 1 - dis2 / lightRange / lightRange;
				//attenuate = 1;

				// diffuse
				float3 diffuse = attenuate * dotLN * lightColor;

				// specular
				float3 specular = pow(dotHN, _Gloss*256) * _Specular * lightColor;
				specular = attenuate * _Specular *  sqrt(dotLN/dotVN) * exp(-2 * (dotHT*dotHT/_AnisoX/_AnisoX + dotHB*dotHB/_AnisoY/_AnisoY)/(1+dotHN));

				
				c.rgb = diffuse + specular;
				c.a = 1.0;
			}


			ENDCG

		}
	}

}
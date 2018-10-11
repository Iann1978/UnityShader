// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader
shader "Iann/Metal/WarChariot6"
{
	Properties
	{
		_Color("Color", Color) = (1.0,1.0,1.0,0.5)
		_Power("Powser", Float) = 2.0
		_Specular("Specular", Float) = 128
		_Gloss("Gloss", Range(0,1)) = 0.5
		_Tex("Texture", 2D) = "blue"
		_Cubemap ("CubeMap", CUBE) = ""{}
		_Param1("Param1", Float) = 1.0

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
			//ZWrite On
			ZTest Less
			ZWrite On
			Cull Back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			uniform float4 _Color;
			uniform float _Power;
			uniform float _Specular;
			uniform float _Gloss;
			uniform sampler2D _Tex;
			samplerCUBE _Cubemap;
			uniform float _Param1;

			float3 Fresnel( float3 NormalDir , float3 ViewDir , float3 RimColor , float RimPower ){
				float rim = 1.0 - saturate(dot(NormalDir,ViewDir));
				return RimColor * pow(rim,RimPower);
            }

			float Fresnel( float3 NormalDir , float3 ViewDir  , float RimPower)
			{
				float rim = 1.0 - saturate(dot(NormalDir,ViewDir));
				return pow(rim,RimPower);
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float3 position : TEXCOORD1;
			};


			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord.xy;
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.position = input.vertex;
			}

			void frag(in v2f input, out float4 c:Color)
			{
				//float3 lightPos = float3(unity_4LightPosX0[0], unity_4LightPosY0[0], unity_4LightPosZ0[0]);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				//float3 tangentDir = UnityObjectToWorldNormal(input.tangent.xyz);
				//float3 bitangentDir = cross(tangentDir, normalDir);
				//float3 normalInTangentScpace = UnpackNormal(tex2D(_Normal, input.uv));
				//float3 normal = normalInTangentScpace.x * tangentDir + normalInTangentScpace.y * bitangentDir + normalInTangentScpace.z * normalDir;
				float3 normal = normalDir;
				//float3 baseColor = tex2D(_Albedo, input.uv).xyz;
				float3 baseColor = _Color;
				float3 eyePos = _WorldSpaceCameraPos.xyz;
				float3 vertPos = mul(unity_ObjectToWorld, float4(input.position,1)).xyz;
				float3 eyeDir = normalize(eyePos - vertPos);
				float3 reflectEye = reflect(-eyeDir,normalDir);
				float3 h = normalize(lightDir + eyeDir);
				float3 NdotL = saturate(dot(normal, lightDir));
				float3 NdotH = saturate(dot(normal, h));
				float3 lightColor = _LightColor0.xyz;
				float3 diffuse = baseColor * lightColor * NdotL;
				float3 specular = lightColor * pow(NdotH, _Specular) * _Gloss;

				//c.rgb = diffuse + specular;
				//c.rgb = specular;
				//c.a = 1;
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.position.xyz);
				//float a = _Color.a*Fresnel(normalDir,viewDir,_Power);
				//float3 fresnel = _Color*Fresnel(normalDir,viewDir,_Power);
				//c.rgb = diffuse + specular;
				//c.a = a;

				float nx = dot(normalize(UNITY_MATRIX_IT_MV[0].xyz), normalize(input.normal));
				float ny = dot(normalize(UNITY_MATRIX_IT_MV[1].xyz), normalize(input.normal));
				float2 normalInView = float2(nx,ny);
				normalInView = pow(abs(normalInView),_Power);
				normalInView = normalInView * 0.5 + 0.5;
				c.rgb = tex2D(_Tex, normalInView);
				//c.a = _Color.a * Fresnel(normalDir,viewDir,_Power);
				//c.rgb = Fresnel(normalDir,viewDir,_Power);
				c.a = _Color.a* Fresnel(normalDir,viewDir,_Power);

				float3 reflectColor = texCUBE(_Cubemap, reflectEye).rgb * _Param1;

				//c.rgb = 
				c.a = 1;

				c.rgb = reflectColor + specular;
				c.rgb *= Fresnel(normalDir,viewDir,_Power) * _Param1;
				c.rgb = diffuse;
				//c.a = 
				return;

				//c = float4(fresnel,a);
			}
			ENDCG
		}
		
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardAdd"
				"RenderType" = "Opaque"
				"Queue" = "Geometry"			
			}

			Blend One Zero
			//ZWrite On
			ZTest Less
			ZWrite On
			Cull Back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			uniform float4 _Color;
			uniform float _Power;
			uniform float _Specular;
			uniform float _Gloss;
			uniform sampler2D _Tex;
			samplerCUBE _Cubemap;
			uniform float _Param1;

			float3 Fresnel( float3 NormalDir , float3 ViewDir , float3 RimColor , float RimPower ){
				float rim = 1.0 - saturate(dot(NormalDir,ViewDir));
				return RimColor * pow(rim,RimPower);
            }

			float Fresnel( float3 NormalDir , float3 ViewDir  , float RimPower)
			{
				float rim = 1.0 - saturate(dot(NormalDir,ViewDir));
				return pow(rim,RimPower);
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float3 position : TEXCOORD1;
			};


			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord.xy;
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.position = input.vertex;
			}

			void frag(in v2f input, out float4 c:Color)
			{
				//float3 lightPos = float3(unity_4LightPosX0[0], unity_4LightPosY0[0], unity_4LightPosZ0[0]);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				//float3 tangentDir = UnityObjectToWorldNormal(input.tangent.xyz);
				//float3 bitangentDir = cross(tangentDir, normalDir);
				//float3 normalInTangentScpace = UnpackNormal(tex2D(_Normal, input.uv));
				//float3 normal = normalInTangentScpace.x * tangentDir + normalInTangentScpace.y * bitangentDir + normalInTangentScpace.z * normalDir;
				float3 normal = normalDir;
				//float3 baseColor = tex2D(_Albedo, input.uv).xyz;
				float3 baseColor = _Color;
				float3 eyePos = _WorldSpaceCameraPos.xyz;
				float3 vertPos = mul(unity_ObjectToWorld, float4(input.position,1)).xyz;
				float3 eyeDir = normalize(eyePos - vertPos);
				float3 reflectEye = reflect(-eyeDir,normalDir);
				float3 h = normalize(lightDir + eyeDir);
				float3 NdotL = saturate(dot(normal, lightDir));
				float3 NdotH = saturate(dot(normal, h));
				float3 lightColor = _LightColor0.xyz;
				float3 diffuse = baseColor * lightColor * NdotL;
				float3 specular = lightColor * pow(NdotH, _Specular) * _Gloss;

				//c.rgb = diffuse + specular;
				//c.rgb = specular;
				//c.a = 1;
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.position.xyz);
				//float a = _Color.a*Fresnel(normalDir,viewDir,_Power);
				//float3 fresnel = _Color*Fresnel(normalDir,viewDir,_Power);
				//c.rgb = diffuse + specular;
				//c.a = a;

				float nx = dot(normalize(UNITY_MATRIX_IT_MV[0].xyz), normalize(input.normal));
				float ny = dot(normalize(UNITY_MATRIX_IT_MV[1].xyz), normalize(input.normal));
				float2 normalInView = float2(nx,ny);
				normalInView = pow(abs(normalInView),_Power);
				normalInView = normalInView * 0.5 + 0.5;
				c.rgb = tex2D(_Tex, normalInView);
				//c.a = _Color.a * Fresnel(normalDir,viewDir,_Power);
				//c.rgb = Fresnel(normalDir,viewDir,_Power);
				c.a = _Color.a* Fresnel(normalDir,viewDir,_Power);

				float3 reflectColor = texCUBE(_Cubemap, reflectEye).rgb * _Param1;

				//c.rgb = 
				c.a = 1;

				c.rgb = reflectColor + specular;
				c.rgb *= Fresnel(normalDir,viewDir,_Power) * _Param1;
				c.rgb = diffuse;
				//c.a = 
				return;

				//c = float4(fresnel,a);
			}
			ENDCG
		}
	}
}
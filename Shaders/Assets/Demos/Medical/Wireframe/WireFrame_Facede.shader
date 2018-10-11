Shader "Iann/WireFrame_Facede" {
    Properties {
		_TintColor("Color", Color) = (0.5,0.5,0.5,1)
		_Offset("Offset",Float) = 0
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "blue" {}
		_Specular("Specular", Float) = 128
		_Gloss("Gloss", Range(0,1)) = 0.5
    }
		
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }

        	Blend SrcAlpha OneMinusSrcAlpha 
			ZWrite On
			ZTest Less
			Lighting Off
			Cull Back
			Offset 1,[_Offset]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
           	#include "UnityCG.cginc"
			#include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			uniform sampler2D _Albedo;
			uniform float4 _TintColor;
			uniform float _Specular;
			uniform float _Gloss;

			
            struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float3 position : TEXCOORD1;
            };

			v2f vert (appdata_tan input) {
                v2f output;
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord.xy;
				output.normal = input.normal;
				output.tangent = input.tangent;
				output.position = input.vertex;

                return output;
            }
			
            fixed4 frag(v2f input) : COLOR {
				fixed4 c; 
				



				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 tangentDir = UnityObjectToWorldNormal(input.tangent.xyz);
				float3 bitangentDir = cross(tangentDir, normalDir);
				//float3 normalInTangentScpace = UnpackNormal(tex2D(_Normal, input.uv));
				//float3 normal = normalInTangentScpace.x * tangentDir + normalInTangentScpace.y * bitangentDir + normalInTangentScpace.z * normalDir;
				float3 normal = normalDir;
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
				c.rgb = _TintColor + specular;
				c.a = (specular.r + specular.g + specular.b) * 0.3;

				c.a = clamp(c.a, _TintColor.a, 1);
				
				//c.a = _TintColor.a + specular

				return c;
            }
            ENDCG
        }        
    }
    FallBack Off
}

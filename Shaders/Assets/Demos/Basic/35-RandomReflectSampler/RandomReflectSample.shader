shader "Iann/Basic/RandomReflectSample"{
	Properties {
		_LastFrame("Last Frame", 2D) = "black"{}
		_Attenuation("Attenuation", Range(0,1)) = 0.5
		_tCount("Tangent Sampler Count", Range(1,100)) = 10
		_bCount("Binormal Sampler Count", Range(1,100)) = 10
		_tOff("Tangent Sampler Offset", Range(0,10)) = 0.5
		_bOff("Binormal Sampler Offset", Range(0,10)) = 0.5
	}

	SubShader {
		Name "Lod 300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _LastFrame;
			float _Attenuation;
			int _tCount, _bCount;
			float _tOff, _bOff;
			int _Index;

			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 vertex : TEXCOORD0;
				float2 texcoord : TEXCOORD1;
				float2 pos1 : TEXCOORD2;
				float4 tangent : TANGENT;
			};

			void vert(in appdata_tan input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				output.normal = input.normal;
				output.vertex = input.vertex;
				output.texcoord = input.texcoord;

				output.pos1.xy = input.texcoord.xy*2-1;
				output.pos1.y = 1-input.texcoord.y;
				output.tangent = input.tangent;

			}

			void frag(in v2f input, out float4 c : COLOR) {
				float3 viewDir = WorldSpaceViewDir(input.vertex);
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 tangentDir = UnityObjectToWorldNormal(input.tangent);
				float3 n = normalize(normalDir);
				float3 t = normalize(tangentDir);
				float3 b = normalize(cross(t,n));
				float3 v = normalize(viewDir);
				
				float3 rv = reflect(-v, n);
				float3 reflectColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rv, 0).xyz;
				float3 lastColor = tex2D(_LastFrame, input.texcoord);
				c.rgb = reflectColor*(1-_Attenuation) + lastColor*_Attenuation;
				c.rgb = 0;
				int tCount = _tCount;
				int bCount = _bCount;
				float tOff = _tOff;
				float bOff = _bOff;
				//c.rgb = reflectColor;
				for (int it=-tCount+1; it<tCount; it++)
				{
					for (int ib=-bCount+1; ib<bCount; ib++)
					{
						float3 drv = rv + it*t*tOff/max(1,(tCount-1))   + ib*b*bOff/max(1,(bCount-1)) ;
						reflectColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, drv, 0).xyz;
						c.rgb += reflectColor;

					}
				}
				c.rgb /= (tCount*2-1) * (bCount*2-1);
				c.rgb = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rv, 0).xyz;
				c.rgb = lastColor;
				//c.rgb = reflectColor;
			}



			ENDCG
		}


	}
}
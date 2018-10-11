

shader "Luci/Theater/BaseEnvReflect" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EnvColor("Environmental Color", Color) = (1,1,1,1)
		_ScreenColor("Screen Color", Color) = (1,1,1,1)
		_ScreenWeight("Screen Color Weight", Float) = 0.3
		_Roughness("Roughness", Float) = 0.5
	}

	SubShader{
		Name "LOD 300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

		Pass {
			Name "ForwardBase"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			sampler2D _MainTex;
			float4 _EnvColor;
			float4 _ScreenColor;
			float _ScreenWeight;
			float _Roughness;
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 vertex : TEXCOORD3;
				float2 texcoord : TEXCOORD0;
			};

			void vert(in appdata_base input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				output.normal = input.normal;
				output.vertex = input.vertex;
				output.texcoord = input.texcoord;
			}



			void frag(in v2f input, out float4 c : COLOR) {
				float3 baseColor = tex2D(_MainTex, input.texcoord.xy).xyz;

				float3 n = normalize(UnityObjectToWorldNormal(input.normal));
				float3 v = normalize(WorldSpaceViewDir(input.vertex));
				float3 r = reflect(-v,n);
				float4 reflectColor = UNITY_SAMPLE_TEXCUBE_LOD(
					unity_SpecCube0, r, _Roughness * UNITY_SPECCUBE_LOD_STEPS
				);

				c = float4(baseColor*(_EnvColor.xyz + baseColor * reflectColor.xyz + _ScreenColor.xyz *_ScreenWeight), 1);

				//c = float4(baseColor*_EnvColor.xyz + baseColor* reflectColor.xyz, 1);
				//c = float4(reflectColor.xyz, 1);
			}
			ENDCG
		}
	}
}
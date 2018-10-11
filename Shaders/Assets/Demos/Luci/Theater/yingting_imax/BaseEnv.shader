

shader "Luci/Theater/BaseEnv" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EnvColor("Environmental Color", Color) = (0,0,0,0)
		_ScreenColor("Screen Color", Color) = (1,1,1,1)
		_ScreenWeight("Screen Color Weight", Float) = 0.3
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
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			void vert(in appdata_base input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				output.texcoord = input.texcoord;
			}

			void frag(in v2f input, out float4 c : COLOR) {
				float3 baseColor = tex2D(_MainTex, input.texcoord.xy).xyz;
				c = float4(baseColor*(_EnvColor.xyz + _ScreenColor.xyz *_ScreenWeight), 1);
			}
			ENDCG
		}
	}
}


shader "Luci/Theater/BaseEnvMirror" {
	Properties{
		_MirrorTex("MirrorTex", 2D) = "white" {}
		_BaseColor("Base Color(RGB)", Color) = (0.05,0.1,0.1,1)
		_Roughness("Roughness", Range(0,8)) = 0
	}
		SubShader{
			Tags {
				"RenderType" = "Transparent" "Queue" = "Transparent"
			}
			Pass {
				Name "FORWARD"
				Tags {
					"LightMode" = "ForwardBase"
				}

			//Blend One One
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase_fullshadows
			#pragma multi_compile_fog
			#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
			#pragma target 3.0
			uniform sampler2D _MirrorTex; uniform float4 _MirrorTex_ST;
			uniform float4x4 _ProjMat;
			uniform float4x4 _ViewMat;
			uniform float4 _BaseColor;
			uniform float _Roughness;
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv :	TEXCOORD0;
				float4 screenPos : TEXCOORD1;
				float4 screenPos2 : TEXCOORD2;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.screenPos = mul(_ProjMat, mul(_ViewMat, mul(unity_ObjectToWorld, v.vertex)));
				o.screenPos2 = o.screenPos;
			}

			void frag(in v2f input, out float4 c : COLOR) {
				input.screenPos = float4(input.screenPos.xy / input.screenPos.w, 0, 0);
				//i.screenPos.y *= _ProjectionParams.x;
				input.screenPos = (input.screenPos + 1) / 2;


				float4 mirrorColor = tex2Dlod(_MirrorTex, float4(input.screenPos.rg,0, _Roughness));
				c = float4(_BaseColor.rgb + mirrorColor.rgb, mirrorColor.a);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
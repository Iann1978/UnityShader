shader "Dx11/Displacement1"
{
	Properties {
		_Tess ("Tessellation", Range(1,32)) = 4
	}

	SubShader {
		Tags { "Queue" = "Geometry" }
		LOD 300
		Pass {
			Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase"}
			Blend One Zero

			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag

			#pragma hull tess
			
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _Tess;

			struct v2f {
				float4 pos : SV_POSITION;
			};

			float4 tess() {
				return _Tess;
			}

			void vert(in appdata_base input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c : COLOR) {
				c.rgb = 0.5;
				c.a = 1.0;
			}
			ENDCG
		}
	}
}
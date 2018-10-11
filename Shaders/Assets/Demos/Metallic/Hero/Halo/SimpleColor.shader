shader "Iann/Hero/Halo/SimpleColor" {
	Properties { 
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero
			Cull Back
			ZWrite Off
			ZTest Off

			CGPROGRAM
			#pragma target 3.0
			#pragma mutil_compile_fwbase
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARD
			#include "UnityCG.cginc"

			float4 _Color;

			struct v2f { 
				float4 pos : SV_POSITION;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
			}

			void frag(in v2f v, out float4 c : COLOR) {
				c = _Color;
				c.a = Linear01Depth(v.pos.z);
				//c.a = 1;
				//c.rgb = Linear01Depth(v.pos.z);
			}
			ENDCG
		}

	}
}
shader "Iann/Basic/ColorAdjust" {
	Properties { 
		_Color ("Color", Color) = (1,1,1,1)
		_Albedo("Albedo", 2D) = "white"
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
			uniform sampler2D _Albedo;

			struct v2f { 
				float4 pos : SV_POSITION;
				float2 texcoord: TEXCOORD0;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
			}

			void frag(in v2f v, out float4 c : COLOR) {
				c = tex2D(_Albedo, v.texcoord) + _Color;
				//c = _Color;
				//c.a = 1;				
			}
			ENDCG
		}

	}
}
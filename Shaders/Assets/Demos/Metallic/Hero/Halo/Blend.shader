shader "Iann/Hero/Halo/Blend" {
	Properties { 
		_HaloColor ("HaloColor", Color) = (1,1,1,1)
		_Albedo ("Albedo", 2D) = "white" {}
		_Alpha("Alpha", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }
			Blend One One
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


			sampler2D _Albedo;
			sampler2D _Alpha;
			float4 _HaloColor;
			sampler2D _CameraDepthTexture;

			struct v2f { 
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
			}

			void frag(in v2f v, out float4 c : COLOR) {

				float z = tex2D(_Albedo, v.uv).a;
				float zz = Linear01Depth(tex2D(_CameraDepthTexture,v.uv).r);
				float dz = zz - z;
				if (dz>0)
					c = tex2D(_Albedo, v.uv).r * (1-tex2D(_Alpha,v.uv));
				else 
					c = 0;
				c *= _HaloColor;

			}
			ENDCG
		}

	}
}
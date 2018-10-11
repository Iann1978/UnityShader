shader "Iann/Basic/BlendBlur" {
	Properties {
		_LerpParam("Lerp Param", Range(0, 1)) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Albedo1("Albedo1", 2D) = "white" {}
	}

	SubShader {
		Name "Lod300"
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		LOD 300

		Pass {
			Name "Blur Blend"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _LerpParam;
			sampler2D _Albedo;
			sampler2D _Albedo1;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			void vert(in appdata_base input, out v2f output) {
				output.pos = UnityObjectToClipPos(input.vertex);
				//output.pos = input.vertex;
				output.texcoord = input.texcoord;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float3 p1 = tex2D(_Albedo, input.texcoord).rgb;
				float3 p2 = tex2D(_Albedo1, input.texcoord).rgb;
				
				c.rgb = lerp(p1, p2, _LerpParam);
				//c.rgb *= 0;
				c.a = 1;
			}


			ENDCG
		}

	}
}
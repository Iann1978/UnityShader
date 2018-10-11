shader "Iann/Basic/Blur" {
	Properties {
		_BlurSize("Blur Size", Range(0, 20)) = 1
		_Albedo("Albedo", 2D) = "white" {}
	}

	SubShader {
		Name "Lod300"
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		LOD 300

		Pass {
			Name "Horizontal Blur"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _BlurSize;
			sampler2D _Albedo;

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
				float4 p = tex2D(_Albedo, input.texcoord);
				float4 p0 = tex2D(_Albedo, float2(input.texcoord.x+_BlurSize/_ScreenParams.x, input.texcoord.y));
				float4 p1 = tex2D(_Albedo, float2(input.texcoord.x-_BlurSize/_ScreenParams.x, input.texcoord.y));
				c.rgb = 0.5 * p.rgb + 0.25 * p0.rgb + 0.25 * p1.rgb;
				//c.rgb *= 0;
				//
				c.a = min(p.a,min(p0.a,p1.a));
			}


			ENDCG
		}

		Pass {
			Name "Vertical Blur"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float _BlurSize;
			sampler2D _Albedo;

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
				float4 p = tex2D(_Albedo, input.texcoord);
				float4 p0 = tex2D(_Albedo, float2(input.texcoord.x, input.texcoord.y + _BlurSize / _ScreenParams.x));
				float4 p1 = tex2D(_Albedo, float2(input.texcoord.x, input.texcoord.y - _BlurSize / _ScreenParams.x));
				c.rgb = 0.5 * p.rgb + 0.25 * p0.rgb + 0.25 * p1.rgb;
				//c.rgb *= 0;
				c.a = min(p.a,min(p0.a,p1.a));
			}


			ENDCG
		}
	}
}
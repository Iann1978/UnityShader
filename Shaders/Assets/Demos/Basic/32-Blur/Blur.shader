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
				float3 p = tex2D(_Albedo, input.texcoord).rgb;
				float3 p0 = tex2D(_Albedo, float2(input.texcoord.x+_BlurSize/_ScreenParams.x, input.texcoord.y)).rgb;
				float3 p1 = tex2D(_Albedo, float2(input.texcoord.x-_BlurSize/_ScreenParams.x, input.texcoord.y)).rgb;
				c.rgb = 0.5 * p + 0.25 * p0 + 0.25 * p1;
				//c.rgb *= 0;
				c.a = 1;
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
				float3 p = tex2D(_Albedo, input.texcoord).rgb;
				float3 p0 = tex2D(_Albedo, float2(input.texcoord.x, input.texcoord.y + _BlurSize / _ScreenParams.x)).rgb;
				float3 p1 = tex2D(_Albedo, float2(input.texcoord.x, input.texcoord.y - _BlurSize / _ScreenParams.x)).rgb;
				c.rgb = 0.5 * p + 0.25 * p0 + 0.25 * p1;
				//c.rgb *= 0;
				c.a = 1;
			}


			ENDCG
		}
	}
}
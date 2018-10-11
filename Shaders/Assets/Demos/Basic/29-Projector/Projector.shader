Shader "Iann/Basic/Projector" 
{

	Properties {
		_ProjTexture("Projector Texture", 2D) = "blue" {}	
	}

	SubShader {
		Name "LOD300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }
		Blend One Zero

		Pass {
			Name "Projector"
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _ProjTexture;
			float4x4 _ProjMatrix;

			struct v2f {
				float4 pos : SV_POSITION;
				float4 vertex : TEXCOORD0;
				float2 texcoord : TEXCOORD1;
			};

			void vert(in appdata_base input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.vertex = input.vertex;
				output.texcoord = input.texcoord;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float4 projCoord = mul(_ProjMatrix, mul(unity_ObjectToWorld, input.vertex));
				projCoord /= projCoord.w;
				if (projCoord.x<-1 || projCoord.x >1 || projCoord.y<-1 || projCoord.y>1)
					discard;
				c = tex2D(_ProjTexture, projCoord.xy/2+0.5);
				//c.rgb = 1;
				c.a = 1;
				//c.rgb = tex2D(_ProjTexture, input.texcoord);
				//c.rgb = 0;
				//c.rg = projCoord.xy/2+0.5;
			}

			ENDCG
		}
	}
	
}
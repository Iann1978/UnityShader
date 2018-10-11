Shader "My/Ambient"
{
	Properties
	{

	}

	SubShader {
		Name "Normal"
		Tags { 
			"Queue" = "Geometry"
		}

		Pass {
			Name "GetAmbient"
			Tags {
				"LightMode" = "ForwardBase"
				"RenderType" = "Opaque"
			}

			Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
			} ;

			void vert(in appdata_base input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				// 我们可以通过这个宏来取得全局环境光ambient.
				c = UNITY_LIGHTMODEL_AMBIENT;

				// 天空环境光
				c = unity_AmbientSky;
				// 赤道环境光
				c = unity_AmbientEquator;
				// 地面环境光
				c = unity_AmbientGround;
				// indirect specular color
				//c =  unity_IndirectSpecColor;
			}
			ENDCG
		}
	}
}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ScreenOrdinate" {
    Properties {
		_BaseColor("Base Color", 2D) = "white"
    }
		
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }


        
        Pass {
            
            ZTest Always
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

            struct VertexInput {
                float4 vertex : POSITION;
            };

			
            struct VertexOutput {
                float4 pos : SV_POSITION;
				float4 posScreen : TEXCOORD0;
            };

			void vert (in VertexInput v, 
				out float4 pos : SV_POSITION,
				out float4 posScreen : TEXCOORD0) {
                //VertexOutput o;
                pos = UnityObjectToClipPos(v.vertex);
				posScreen = UnityObjectToClipPos(v.vertex);
				posScreen /= posScreen.w;
				//posScreen.xy = (posScreen.xy+1)/2;
                //return o;
            }
			
            void frag(
				in float4 pos : SV_POSITION,
				in float4 posScreen : TEXCOORD0,
				out fixed4 c:COLOR)
			{



				c.r = pos.x/_ScreenParams.x;
				c.g = pos.y/_ScreenParams.y;


				c.b = 0;
				for (int j = 0; j <= 10; j++)
				{
					float g = j*0.1;
					float e = 0.005;
					float min = g - e;
					float max = g + e;
					if (c.r > min && c.r < max) c.b = 1;
					if (c.g > min && c.g < max) c.b = 1;
				}

				c.a = 1;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

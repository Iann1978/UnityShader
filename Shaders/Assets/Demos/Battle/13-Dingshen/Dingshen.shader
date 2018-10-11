// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Dingshen" {
    Properties {
		_DingshenTex("Dingshen Texture", 2D) = "white" {}
    }
		
    SubShader {
        Tags {
            "RenderType"="Transparent"
        }
        
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }


            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			sampler2D _DingshenTex;
            struct appdata {
                float4 vertex : POSITION;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float4 posScreen : TEXCOORD1;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
				o.posScreen.xy = ((o.posScreen+1)/2).xy;
                return o;
            }
			
            float4 frag(v2f i) : COLOR {
				float2 dingshenUV = i.posScreen.xy;
				dingshenUV.y += _Time.x;

				float4 c = tex2D(_DingshenTex, dingshenUV);
				
				return c;
            }
            ENDCG
        }        
    }
}

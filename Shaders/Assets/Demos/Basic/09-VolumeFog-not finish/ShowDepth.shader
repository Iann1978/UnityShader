// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ShowDepth" {
    Properties {
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
            //DeapthWrite Off
			ZWrite Off
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

			sampler2D _CameraDepthTexture;
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
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				float u = (i.posScreen.x+1)/2;				
				float v = (i.posScreen.y+1)/2;
				float2 d = tex2D(_CameraDepthTexture, float2(u,v));
				d.x = Linear01Depth(d.x);
				fixed4 c; 
				
				c.r = d.x;
				c.g = 0;
				c.b = 0;
				c.a = 0.1;
				return c;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

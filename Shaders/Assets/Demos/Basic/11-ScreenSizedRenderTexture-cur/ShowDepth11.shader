// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ShowDepth11" {
    Properties {
		_DepthTex("Depth Texture", 2D) = "white" {}
		
    }
		
    SubShader {
        Tags {
        }
        
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
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

			uniform sampler2D _DepthTex;

            struct appdata {
                float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 posScreen : TEXCOORD1;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
				o.posScreen.xy = (o.posScreen.xy + float2(1,1))/2;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				//c.r = LinearEyeDepth(i.pos.z);
				
				//c.r = Linear01Depth(i.pos.z);
				
				
				c.g = 1;
				c.b = 1;
				c.a = 1;
				return tex2D(_DepthTex, i.posScreen.xy);
				return c;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/OverDraw" {
    Properties {
    }
		
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            BlendOp Add
			Blend One One
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
				float4 posScreen : TEXCOORD1;
            };

			VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
				//o.posScreen.xy = (o.posScreen.xy + float2(1,1))/2;

                return o;
            }
			
            fixed4 frag(VertexOutput i) : COLOR {
				fixed4 c; 
				c.r = 0.2;				
				c.g = 0.2;
				//c.r = i.posScreen.x;
				//c.g = i.posScreen.y;
				
				//c.b = tex2D(_Depth,c.rg).r;
				c.a = 1;
				return c;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

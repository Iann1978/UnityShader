// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Depth11" {
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
            };

			VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
			
            fixed4 frag(VertexOutput i) : COLOR {
				fixed4 c; 
				//c.r = LinearEyeDepth(i.pos.z);
				
				c.r = Linear01Depth(i.pos.z);
				
				
				c.g = 0;
				c.b = 0;
				c.a = 1;
				return c;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

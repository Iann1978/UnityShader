Shader "My/ShowDepth" {
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


            struct appdata {
                float4 vertex : POSITION;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.pos /= o.pos.w;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				c.rgb = Linear01Depth(i.pos.z);
				

                
				c.a = 1;
				return c;
            }
            ENDCG
        }        
    }
    FallBack Off
}

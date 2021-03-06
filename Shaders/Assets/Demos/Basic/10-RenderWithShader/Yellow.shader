﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Yellow" {
    Properties {
    }
		
    SubShader {
        Tags {
            //"RenderType"="Opaque"
        }
        
		 Pass {
            //Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#include "UnityCG.cginc"
            

            struct appdata {
                float4 vertex : POSITION;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				return fixed4(1,1,0,1);
            }
            ENDCG
        } 
		
      
		
    }
    FallBack "Diffuse"
}

﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Scale" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
    }
		
    SubShader {
    
        Pass {

			ZTest Always
			ZWrite Off
                       
            CGPROGRAM
			#pragma target 3.0
			#include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
			sampler2D _MainTex; float4 _MainTex_ST;

            struct appdata {
                float4 vertex : POSITION;
				float2 uv0 : TEXCOORD0;
            };
						
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.uv0,_MainTex);
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				return tex2D(_MainTex, i.uv0);
            }
            ENDCG
        }        
    }
    
}

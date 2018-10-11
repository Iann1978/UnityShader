// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Blend" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_BlendTex("Blend Texture", 2D) = "white" {}
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
			sampler2D _MainTex;
			sampler2D _BlendTex;

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
				o.uv0 = v.uv0;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				return tex2D(_MainTex, i.uv0)*0.5+tex2D(_BlendTex, i.uv0)*0.5;
            }
            ENDCG
        }        
    }
    
}

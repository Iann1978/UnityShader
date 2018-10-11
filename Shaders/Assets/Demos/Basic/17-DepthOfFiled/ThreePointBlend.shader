// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ThreePointBlend" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
    }
		
    SubShader {
    
        Pass {
           
            
			ZTest Always
            
            CGPROGRAM
			#pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
			sampler2D _MainTex;
            struct appdata {
                float4 vertex : POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;		
            };
						
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv0 = v.uv0;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c0 = tex2D(_MainTex, i.uv0);
				fixed4 c1 = tex2D(_MainTex, i.uv1);
				fixed4 c2 = tex2D(_MainTex, i.uv2);
				return c0 * 0.5 + c1 * 0.25 + c2 * 0.25;
            }
            ENDCG
        }        
    }
    
}

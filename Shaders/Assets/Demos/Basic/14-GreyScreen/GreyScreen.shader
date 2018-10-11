// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GreyScreen" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
    }
		
    SubShader {
    
        Pass {
           
            
			ZTest Always
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			sampler2D _MainTex;
            struct appdata {
                float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
            };
						
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv*2;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c = tex2D(_MainTex, i.uv);
				c.rgb = (c.r + c.g + c.b)/3;				
				return c;
            }
            ENDCG
        }        
    }
    
}

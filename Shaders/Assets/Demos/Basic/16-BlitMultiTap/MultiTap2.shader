// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MutilTap2" {
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
				float4 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
            };
						
            struct v2f {
                float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.uv2 = v.uv2;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c1 = tex2D(_MainTex, i.uv.xy);
				fixed4 c2 = tex2D(_MainTex, i.uv2);
				//c.rgb = (c.r + c.g + c.b)/3;				
				return (c2+c1)/2;
            }
            ENDCG
        }        
    }
    
}

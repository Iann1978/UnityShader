// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Gradient" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_TopColor("Top Color", Color) = (0,0,0,1)
		_BottomColor("Bottom Color", Color) = (1,1,1,1)
    }
		
    SubShader {
    
        Pass {
           
            
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			sampler2D _MainTex;
			uniform float4 _TopColor;
            uniform float4 _BottomColor;
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
				o.uv = v.uv;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c = tex2D(_MainTex, i.uv);
				c.rgb = c.rgb * lerp(_TopColor, _BottomColor, i.uv.y);	
							
				return c;
            }
            ENDCG
        }        
    }
    
}

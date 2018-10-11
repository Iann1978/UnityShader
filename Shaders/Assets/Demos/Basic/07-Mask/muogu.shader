// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/muogu" {
    Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Flame ("Flame (RGB)", 2D) = "white" {}
		_Mask ("Mask (RGB)", 2D) = "white" {}
		_Speed ("Speed", Float) = 1.0
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
			uniform sampler2D _MainTex;
			uniform sampler2D _Flame; uniform float4 _Flame_ST;
			uniform sampler2D _Mask;
			uniform float _Speed;

            struct app {
                float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
            };

			v2f vert (app v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				float mask = tex2D(_Mask, i.uv).r;
				fixed4 c1 = tex2D(_MainTex, i.uv);
				float2 uv = TRANSFORM_TEX(i.uv,_Flame);
				uv.y += _Time.y * _Speed;
				fixed4 c2 = tex2D(_Flame, uv);
				//c2 *= (2+_SinTime.w);				
				c = c1 * (1-mask) + c2 * mask;
				return c;
            }
            ENDCG
        }        
    }
    FallBack "Diffuse"
}

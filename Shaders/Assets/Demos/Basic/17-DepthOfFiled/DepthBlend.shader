// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DepthBlend" {
    Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_BlendTex("Blend Texture", 2D) = "white" {}
		_FocusDepth("Focus Depth", Float) = 0.5
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
			sampler2D _CameraDepthTexture;
			uniform float _FocusDepth;

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
				float2 uv = i.uv0;
				float2 filpuv = float2(i.uv0.x, 1-i.uv0.y);
				float4 c0 = tex2D(_MainTex,uv);
				float4 c1 = tex2D(_BlendTex,filpuv);
				float depth = LinearEyeDepth(tex2D(_CameraDepthTexture, filpuv).r);
				float focus = _FocusDepth;
				//float deita = abs(depth.r - focus);
				//return c1;
				return lerp(c0,c1,abs(depth-focus)/1000);
				//return focus;
				//return c1;
				//return depth;
				//return c0*(1-deita)+c1*deita;
            }
            ENDCG
        }        
    }
    
}

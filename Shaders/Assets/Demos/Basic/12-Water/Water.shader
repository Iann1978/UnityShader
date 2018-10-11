// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Water" {
    Properties {
		_DepthTex("Depth Texture", 2D) = "white" {}
		
    }
		
    SubShader {
        Tags {
        }
        
        Pass {
            Name "ForwardBase"
            Tags {
                //"LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZTest Always
			//Blend Src OneMinusSrcAlpha
			ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			uniform sampler2D _DepthTex;
			uniform sampler2D _CameraDepthTexture;

            struct appdata {
                float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 posScreen : TEXCOORD1;
				float4 posView : TEXCOORD2;
            };

			v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
				o.posScreen.xy = (o.posScreen.xy + float2(1,1))/2;
				o.posView = mul(UNITY_MATRIX_MV, v.vertex);
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				
				c.r = tex2D(_CameraDepthTexture, i.posScreen.xy).r;
				//c.g = tex2D(_CameraDepthTexture, i.uv).g;
				float zBack = LinearEyeDepth(c.r);
				float zCur = LinearEyeDepth(i.pos.z);
				float dis = zBack - zCur;
				if (dis>1)
				{
					discard;
				}


				c.r = zBack;
				
				
				c.b = 0;
				c.a = dis;
				//return tex2D(_CameraDepthTexture, i.posScreen.xy);
				return c;
				return c;
            }
            ENDCG
        }        
    }
    //FallBack "Diffuse"
}

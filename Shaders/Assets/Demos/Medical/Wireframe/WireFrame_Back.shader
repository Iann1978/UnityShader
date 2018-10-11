Shader "Iann/WireFrame_Back" {
    Properties {
		_TintColor("Color", Color) = (0.5,0.5,0.5,1)
		_Offset("Offset",Float) = 0
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

        	Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			ZTest Less
			Lighting Off
			Cull Off
			Offset 0,0
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			uniform float4 _TintColor;
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
				fixed4 c; 
				c.rgba = _TintColor;
				return c;
            }
            ENDCG
        }        
    }
    FallBack Off
}

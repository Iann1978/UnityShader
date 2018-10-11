// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/VolumeShadow" {
    Properties {
		_LightPosition("Light Position" , Vector) = (1,0,0,1)
		_ExtLength("Ext Length", Float) = 10
    }
		
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        
		 Pass {
            //Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
			Cull Front
            BlendOp Add
			Blend One One
			//ZTest Always
			
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			uniform float4 _LightPosition;
			uniform float _ExtLength;

            struct appdata {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float4 posScreen : TEXCOORD1;
            };

			v2f vert (appdata v) {
                v2f o;
				float3 normal_w = UnityObjectToWorldDir(v.normal);
				float3 position_w = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 toLight_w = _LightPosition.xyz - position_w;
				toLight_w = normalize(toLight_w);
				float deita = dot(normal_w, toLight_w);
				if (deita<0)
				{
					position_w -= toLight_w * _ExtLength;
				}
				

                o.pos = mul(UNITY_MATRIX_VP, float4(position_w,1));
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				c.r = 0.5;				
				c.g = 0.5;
				c.b = 0.5;
				c.a = 0;
				return c;
            }
            ENDCG
        } 
		
        Pass {
            //Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
			Cull Back
            BlendOp RevSub
			Blend One One
			//ZTest Always
			
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0

			uniform float4 _LightPosition;
			uniform float _ExtLength;

            struct appdata {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

			
            struct v2f {
                float4 pos : SV_POSITION;
				float4 posScreen : TEXCOORD1;
            };

			v2f vert (appdata v) {
                v2f o;
				float3 normal_w = UnityObjectToWorldDir(v.normal);
				float3 position_w = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 toLight_w = _LightPosition.xyz - position_w;
				toLight_w = normalize(toLight_w);
				float deita = dot(normal_w, toLight_w);
				if (deita<0)
				{
					position_w -= toLight_w * _ExtLength;
				}
				

                o.pos = mul(UNITY_MATRIX_VP, float4(position_w,1));
				o.posScreen = UnityObjectToClipPos(v.vertex);
				o.posScreen /= o.posScreen.w;
                return o;
            }
			
            fixed4 frag(v2f i) : COLOR {
				fixed4 c; 
				c.r = 0.5;				
				c.g = 0.5;
				c.b = 0.5;
				return c;
            }
            ENDCG
        } 
        
		
    }
    FallBack "Diffuse"
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

shader "Iann/Basic/Isohypse" {
	Properties {
		_LineWidth ("Line Width", Float) = 0.05

	}

	SubShader { 
		Name "Lod300"
		LOD 300
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
		Pass {
			Name "ForwardBase"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero

			CGPROGRAM
			#pragma target 3.0
			


			#pragma multi_compile_fwdbase // if you want to use shadow map , you must write this
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE 
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc" 
			
			uniform float _LineWidth;
			struct v2f { 
				float4 pos : SV_POSITION;
				float4 vertex : TEXCOORD0;
				float3 normal : NORMAL;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				o.vertex = v.vertex;
				o.vertex /= v.vertex.w;
				o.normal = v.normal;
			}

			void frag(in v2f v, out float4 c : COLOR) {
				c = 0;

				float3 a = v.vertex.xyz;
				float4 aaa = mul(UNITY_MATRIX_MV, float4(a,1)); aaa/=aaa.w;
				float3 worldNormal = v.normal;
				worldNormal = normalize(worldNormal);
				float d2 = abs(-aaa.z/_ScreenParams.x);
				float d3 = abs(d2 * sqrt(1-worldNormal.z*worldNormal.z)/worldNormal.z);

				for (float y = -1; y<1; y+=0.05)
				{

					
					float d1 = abs(v.vertex.y - y);
					
					if (d1<d2 && d1<d3)
					{
						
						

						float3 b = v.vertex.xyz; b.y = y;
						
						float3 e = v.vertex.xyz; e.x +=d2;
						//float3 f = v.vertex.xyz; f.z +=d;
						float4 aa = UnityObjectToClipPos(float4(a,1)); aa/=aa.w;
						
						float4 bb = UnityObjectToClipPos(float4(b,1)); bb/=bb.w;
						float4 ee = UnityObjectToClipPos(float4(e,1)); ee/=ee.w;
						//float4 ff = mul(UNITY_MATRIX_MVP, float4(f,1)); ff/=ff.w;
						float dx1 = abs(((aa.x+1)/2*_ScreenParams.x) - ((bb.x+1)/2*_ScreenParams.x));
						float dy1 = abs(((aa.y+1)/2*_ScreenParams.y) - ((bb.y+1)/2*_ScreenParams.y));
						float dx2 = abs(((aa.x+1)/2*_ScreenParams.x) - ((ee.x+1)/2*_ScreenParams.x));
						float dy2 = abs(((aa.y+1)/2*_ScreenParams.y) - ((ee.y+1)/2*_ScreenParams.y));
						//float dx3 = abs(((aa.x+1)/2*_ScreenParams.x) - ((ff.x+1)/2*_ScreenParams.x));
						//float dy3 = abs(((aa.y+1)/2*_ScreenParams.y) - ((ff.y+1)/2*_ScreenParams.y));

						float deita = 0.5;
						if (dx1<deita && dy1<deita && dx2<deita && dy2<deita)
						{
							c = 1;
							//c = d1;
						}
					}

					
					//c = -aaa.z ;
				}
				
				


				//if (v.vertex.y>-_LineWidth && v.vertex.y<_LineWidth)
				//	c = 1;
				//else 
				//	c = 0;
			}
			ENDCG
		}

	}
	//Fallback "VertexLit"
}
shader "Iann/Basic/RandomReflectSample_FrameWriter"{
	Properties {
		_Albedo("Albedo", 2D) = "white" {}
	}

	SubShader {
		Name "Lod 300"
		LOD 300
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

		Pass {
			Name "Forward Base"
			Tags { "LightMode" = "ForwardBase" }
			Blend One Zero
			ZTest Always
			Cull Off

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _LastFrame;
			int _Index;


			struct v2f {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float4 vertex : TEXCOORD0;
				float2 texcoord : TEXCOORD1;
			};

			void vert(in appdata_base input, out v2f output) {
				output.pos.xy = input.texcoord.xy*2-1;
				output.pos.y = -output.pos.y;
				output.pos.z = 1;
				output.pos.w = 1;
				output.normal = input.normal;
				output.vertex = input.vertex;
				output.texcoord = input.texcoord;
				


				// output.pos = UnityObjectToClipPos(input.vertex);
				// output.normal = input.normal;
				// output.vertex = input.vertex;

			}

			void frag(in v2f input, out float4 c : COLOR) {
				float3 viewDir = WorldSpaceViewDir(input.vertex);
				float3 normalDir = UnityObjectToWorldNormal(input.normal);
				float3 v = normalize(viewDir);
				float3 n = normalize(normalDir);
				float3 rv = reflect(-v, n);
				// c.rgb = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rv, 0);
				//c = tex2D(_Albedo, input.texcoord);
				// c.rgb = 0.51;
				// c.r = 0;
				// c.g = 1;
				// 
				// c.b = 0;
				//c.a = 1;
				
				int it = _Time%3;
				float3 drv = rv + float3(0,1,0) * sin(_Time.y*1000) * 0.5;
				float3 lastColor = tex2D(_LastFrame, input.texcoord);
				float3 currentColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, drv, 0);
				c.rgb = lastColor*0.99 + currentColor*0.01;


				//c.rgb  = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rv, 0);
				//c.lastColor = lastColor
				c.a = 1;
				//c.rgb = tex2D(_LastFrame,input.texcoord);
			}



			ENDCG
		}
	}
}
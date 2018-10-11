Shader "Iann/Metallic/Dissolving" {
	Properties {
		_StartColor ("Color", Color) = (1,1,1,1)
		_EndColor ("Collor", Color) = (0,0,0,0)
		_NoiseTex ("Albedo (RGB)", 2D) = "white" {}
		_DissolvingPercent("Dissolving Percent", Range(0,1)) = 0.5
	}
	SubShader {

		Pass{
			Tags { "RenderType"="Opaque" }
			LOD 200
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			uniform float4 _StartColor;
			uniform float4 _EndColor;
			uniform sampler2D _NoiseTex; uniform float4 _NoiseTex_ST;
			uniform float _DissolvingPercent;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			void vert (in appdata_base input, out v2f output) 
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.texcoord = input.texcoord;
			}

			void frag(in v2f input, out float4 output:Color)
			{
				float4 c = tex2D(_NoiseTex, TRANSFORM_TEX(input.texcoord, _NoiseTex)) + _DissolvingPercent*2-1;
				c = clamp(c,0,1);
				output = lerp(_StartColor, _EndColor, c);
			}
			ENDCG
	
		}
	}
}

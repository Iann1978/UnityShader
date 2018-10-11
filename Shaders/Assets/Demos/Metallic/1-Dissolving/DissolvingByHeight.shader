Shader "Iann/Metallic/DissolvingByHeight" {
	Properties {
		_StartColor ("Color", Color) = (1,1,1,1)
		_EndColor ("Collor", Color) = (0,0,0,0)
		_NoiseTex ("Albedo (RGB)", 2D) = "white" {}
		_DissolvingColor ("Dissolving Color", 2D) = "white" {}
		_DissolvingHeight("Dissolving Height", Float) = 0.2
		_DissolvingCenterY("Dissolving CenterY", Float) = 0.5
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
			uniform sampler2D _DissolvingColor;
			uniform float _DissolvingHeight;
			uniform float _DissolvingCenterY;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
			};

			void vert (in appdata_base input, out v2f output) 
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.worldPos = mul(UNITY_MATRIX_M, input.vertex);
				output.texcoord = input.texcoord;
			}

			void frag(in v2f input, out float4 output:Color)
			{
				float y = input.worldPos.y;
				float ymin = _DissolvingCenterY - _DissolvingHeight/2;
				float ymax = _DissolvingCenterY + _DissolvingHeight/2;
				float percent = clamp((y - ymin)/(ymax-ymin), 0, 1);				
				float4 c = tex2D(_NoiseTex, TRANSFORM_TEX(input.texcoord, _NoiseTex)) + percent*2-1;				
				//c.a = 1;
				c = clamp(c,0,1);
				if (percent<=0)
				{
					output = _StartColor;
				}
				else if (percent>=1)
				{
					output = _EndColor;
				}
				else 
				{
					output = lerp(_StartColor, _EndColor, c);
					//output = tex2D(_DissolvingColor, float2(percent, 0.5));
					//output = tex2D(_DissolvingColor, float2(c.r, 0.5));
				}
				
			}
			ENDCG
	
		}
	}
}

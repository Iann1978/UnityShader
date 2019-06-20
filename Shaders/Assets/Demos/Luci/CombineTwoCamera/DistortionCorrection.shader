// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader

shader "Iann/Luci/DistortionCorrection"
{
	Properties
	{
		//_BaseTexture("Base Texture", 2D) = "white"{}
	}

	SubShader
	{
		Pass
		{
			Cull Off
			//ZWrite On
			ZTest Always
			//Blend One Zero

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			sampler2D _ScreenSampler;
			

			void vert(in appdata input, out v2f output)
			{
				output.pos = input.vertex;
				output.pos.z = 0.2f;
				output.uv = input.uv;
				//output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c:Color)
			{
				c = tex2D(_ScreenSampler, input.uv.xy);
				//c = float4(,1,1);
			}
			ENDCG
		}
	}
}
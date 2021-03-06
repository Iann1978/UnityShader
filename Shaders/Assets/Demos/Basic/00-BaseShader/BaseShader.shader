// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader

shader "Iann/Basic/BaseShader"
{
	Properties
	{

	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				//output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c:Color)
			{
				c = float4(1,1,1,1);
			}
			ENDCG
		}
	}
}
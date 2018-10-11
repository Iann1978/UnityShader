// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader

shader "My/Basic/PureColor"
{
	Properties
	{
		_MainColor("Main Color", Color) = (1,0,0,0)
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent" 
			}

			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4 _MainColor;

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
			}

			void frag(in v2f input, out float4 c : Color)
			{
				c = _MainColor;
			}
			ENDCG
		}
	}
}
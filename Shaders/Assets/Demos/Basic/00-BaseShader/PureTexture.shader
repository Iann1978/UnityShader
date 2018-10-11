// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Pure Texture

shader "My/Basic/PureTexture"
{
	Properties
	{
		_BaseTexture("Base Texture", 2D) = "white"{}
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				"Queue" = "Geometry"
				"RenderType" = "Opaque"
			}

			Blend SrcAlpha OneMinusSrcAlpha
			ZTest Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _BaseTexture;

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

			void vert(in appdata input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.uv = input.uv;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				c = tex2D(_BaseTexture, input.uv);
			}

			ENDCG
		}
	}
}
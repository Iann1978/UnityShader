// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// base shader

shader "My/Basic/Line3D"
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
				float3 rst: TEXCOORD1;
			};

			void vert(in appdata input, out v2f output)
			{
				float r = 0;
				float s = 0;
				float t = 0;
				if (input.vertex.x < 0 && input.vertex.y < 0)
					r = 1;
				else if (input.vertex.y > 0)
					s = 1;
				else
					t = 1;
				output.rst = float3(r, s, t);

				output.pos = UnityObjectToClipPos(input.vertex);
				//output.pos = UnityObjectToClipPos(input.vertex);
			}

			void frag(in v2f input, out float4 c:Color)
			{	
				float threshold = 0.05;
				if (input.rst.x<threshold || input.rst.y<threshold || input.rst.z<threshold)
					c = float4(1, 1, 0, 1);
				else 
					c = float4(0.2, 0.2, 0.2, 1);
			}
			ENDCG
		}
	}
}
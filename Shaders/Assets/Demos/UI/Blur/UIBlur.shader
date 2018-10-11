// UI Blur

shader "My/UI/Blur"
{
	Properties
	{

	}

	SubShader
	{
		


		GrabPass{}

		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
				"RenderType" = "Opaque"
				"Queue" = "Gerometry"
			}

			Blend One Zero
			ZWrite Off
			

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			sampler2D _GrabTexture;

			struct v2f
			{
				float4 pos : POSITION;
				float4 grabUv : TEXCOORD0;
			};

			void vert(in appdata_base input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.grabUv = ComputeGrabScreenPos(output.pos);
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float x = input.grabUv.x;
				float y = input.grabUv.y;
				float dx = _ScreenParams.z-1;
				float dy = _ScreenParams.w-1;

				c = 0;
				int off = 3;
				for (int i=-off; i<=off; i++)
				{
					for (int j=-off; j<=off; j++)
					{
						c += tex2D(_GrabTexture, float2(x+dx*i, y+dy*j));
					}
				}
				
				c /= (2*off+1)*(2*off+1);
				// float2 uv = float2(x, y);
				// float2 uv1 = float2(x + dx, y);
				// float2 uv2 = float2(x - dx, y);
				// float2 uv3 = float2(x, y + dy);
				// float2 uv4 = float2(x, y - dy);

				// float4 c0 = tex2D(_GrabTexture, uv);
				// float4 c1 = tex2D(_GrabTexture, uv1);
				// float4 c2 = tex2D(_GrabTexture, uv2);
				// float4 c3 = tex2D(_GrabTexture, uv3);
				// float4 c4 = tex2D(_GrabTexture, uv4);

				// c = (c0 + c1 + c2 + c3 + c4)/5.0;
			}
			ENDCG
		}
	}
}
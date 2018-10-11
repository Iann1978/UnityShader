// Thickness

shader "My/Thickness"
{
	Properties
	{

	}

	SubShader 
	{


		GrabPass{}
		Tags
		{
			//"LightMode" = "ForwardBase"
			"RenderType" = "Opaque"
			"Queue" = "Transparent+100"
		}

		Pass {
			Name "Back"

			Tags
			{
				"LightMode" = "ForwardBase"
			}
			

			//Blend One Zero
			//ZWrite Off
			Cull Front
			//Blend One Zero
			ZTest Always
			//ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"

			sampler2D _CameraDepthTexture;
			sampler2D _GrabTexture;
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 screenPos : TEXCOORD1;
			};


			void vert(in appdata_base input, out v2f output)
			{
				output.pos = UnityObjectToClipPos(input.vertex);
				output.screenPos = ComputeScreenPos(output.pos);
				output.screenPos /= output.screenPos.w;
			}

			void frag(in v2f input, out float4 c : COLOR)
			{
				float rr = input.pos.x/_ScreenParams.x;
				float gg = input.pos.y/_ScreenParams.y;
				float dn = Linear01Depth(tex2D(_CameraDepthTexture, float2(rr,1-gg)).r);
				float df = Linear01Depth(input.pos.z);
				
				//c.rgb += 0.1;
				//c.rgb = dn;
				
				c.rgb = dn;
				//c.b = 0;
				for (int j = 0; j <= 10; j++)
				{
					float g = j*0.1;
					float e = 0.005;
					float min = g - e;
					float max = g + e;
					if (rr > min && rr < max) c.b = 0;
					if (gg > min && gg < max) c.b = 0;
				}
				c.a = 1;
			}
			ENDCG



		}
	}
	FallBack "Diffuse"
}
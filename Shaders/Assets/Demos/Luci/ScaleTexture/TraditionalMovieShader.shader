// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TraditionalMovieShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness ("Brightness", float) = 0.8
		_Eyeindex ("Eyeindex", int) = 0
		//_Stereo ("Stereo", int) = 0
		//_Ratio("Ratio", float) = 1					// w/h
		//_TypeRatio("TypeRatio", int) = 0
		//_WidthRatio("WidthRatio", float) = 1		// width / texture width
		//_HeightRatio("HeightRatio", float) = 1		// height / texture height
		_UMin("UMin", float) = 0
		_UMax("UMax", float) = 1
		_VMin("VMin", float) = 0
		_VMax("VMax", float) = 1

	}
	SubShader
	{
    	CULL OFF
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			//float4 _MainTex_ST;
			float _Brightness; 
			int _Eyeindex;
			//int _Stereo;
			//float _Ratio;
			//int _TypeRatio;
			//float _WidthRatio;
			//float _HeightRatio;
			float _UMin;
			float _UMax;
			float _VMin;
			float _VMax;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				if (_Eyeindex == 0)
					o.uv = v.uv;
				else
					o.uv = v.uv2;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0, 0, 0, 1);

				if (i.uv.x > _UMax) return col;
				if (_UMin > i.uv.x) return col;
				if (i.uv.y > _VMax) return col;
				if (_VMin > i.uv.y) return col;
				col = tex2D(_MainTex, i.uv);
				
				return col * _Brightness;
			}
			ENDCG
		}
	}
}

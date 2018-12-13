// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Iann/Basic/Pipe"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Float) = 0.1
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CULL OFF
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};


			struct v2f
			{
				float4 vertex : SV_POSITION;
				//float3 normal : NORMAL;
				//float2 uv : TEXCOORD0;
				float3 worldPosition : TEXCOORD1;
			};

			sampler2D _MainTex;
			uniform float _Radius;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = v.uv;
				//o.normal = v.normal;
				o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			[maxvertexcount(6*20)]                                                //表示最后outputStream中的v2f数据是3个
			void geom(line v2f input[2], inout TriangleStream<v2f> OutputStream)
			{
				OutputStream.RestartStrip();

				float3 v0 = input[0].worldPosition;
				float3 v1 = input[1].worldPosition;
				float3 v2 = float3(0, 1, 0);

				float3 axial = normalize(v1 - v0);
				float3 right = float3(1, 0, 0);
				float3 up = float3(0, 1, 0);
				float deita1 = abs(dot(axial, right));
				float deita2 = abs(dot(axial, up));
				float3 radial0 = deita1 < deita2 ? cross(axial, right) : cross(axial, up);
				float3 radial1 = cross(axial, radial0);
				float radius = _Radius;


				const float PI = 3.1415926535897932384626433832795;
				v2f o = (v2f)0;
				//o.normal = n;
				for (int i = 0; i < 20; i++)
				{
					float a0 = i * PI * 2 / 20;
					float a1 = (i + 1) * PI * 2 / 20;
					float3 vv0 = v0 + radial0 * radius * cos(a0) + radial1 * radius * sin(a0);
					float3 vv1 = v0 + radial0 * radius * cos(a1) + radial1 * radius * sin(a1);
					float3 vv2 = v1 + radial0 * radius * cos(a1) + radial1 * radius * sin(a1);
					float3 vv3 = v1 + radial0 * radius * cos(a0) + radial1 * radius * sin(a0);
					o.vertex = UnityWorldToClipPos(vv0);
					OutputStream.Append(o);
					
					o.vertex = UnityWorldToClipPos(vv1);
					OutputStream.Append(o);

					o.vertex = UnityWorldToClipPos(vv2);
					OutputStream.Append(o);

					o.vertex = UnityWorldToClipPos(vv0);
					OutputStream.Append(o);

					o.vertex = UnityWorldToClipPos(vv2);
					OutputStream.Append(o);

					o.vertex = UnityWorldToClipPos(vv3);
					OutputStream.Append(o);
				}
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(0.8,0.8,0.8,1);
			}
			ENDCG
		}
	}
}

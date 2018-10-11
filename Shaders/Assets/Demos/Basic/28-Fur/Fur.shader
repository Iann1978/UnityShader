Shader "Iann/Basic/Fur" {
	Properties {
		_Albedo ("Albedo", 2D) = "white" {}
		_Normal ("Normal Map", 2D) = "blue" {}
		_FurThickness("Fur Thickness", Float) = 0.2
	}


	SubShader {
		Name "Fur20"
		LOD 200
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

		Pass {
			Name "Fur Base"
			Tags { "LightMode" = "ForwardBase" }
			//Blend One Zero

			CGPROGRAM
			//#pragma target 5.0
			#define LAYER_PARAM 0.00
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}


		Pass {
			Name "Fur Layer 1_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.05
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 2_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.10
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 3_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.15
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 4_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.20
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 5_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.25
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 6_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.30
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 7_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.35
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

		Pass {
			Name "Fur Layer 8_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.40
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 9_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.45
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 10_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.50
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 11_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.55
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 12_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.60
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 13_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.65
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 14_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.70
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 15_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.75
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 16_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.80
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 17_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.85
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 18_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.90
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 19_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 0.95
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}
		Pass {
			Name "Fur Layer 20_20"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#define LAYER_PARAM 1.00
			#pragma vertex vert
			#pragma fragment frag
			#include "furbase.cginc"
			ENDCG
		}

	}
}
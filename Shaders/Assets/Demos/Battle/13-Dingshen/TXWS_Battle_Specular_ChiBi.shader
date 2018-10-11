Shader "TXWS_Battle_Specular_ChiBi" {
	Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Color ("Main Color", Color) = (0.6313,0.6313,0.6,1)
	_AddColor ("Add Color", Color) = (0.0,0.0,0.0,0.0)
	_LightColor("Light Color" , Color) = (0.1019,0.0156,0.0156,1)
	_LightDir("Light Direction" , Vector) = (-0.17,10.07,5.06,0)
	_SpecularColor("Specular Color" , Color) = (0.29411,0.27843,0.27843,1)
	_Warp("Warp lighting", float) = 2.97
	_Ambient("Ambient Light", float) = 0.72
	_Shininess ("Shininess", float) = 5.84
	//_Cutoff("Cutoff", float) = 0.5
	}
	SubShader {	
		Tags { "Queue" = "Geometry-500" "RenderType" = "Opaque" }
		

		Stencil {
                Ref 2
                Comp always
                Pass replace
                //ZFail decrWrap
        }
		CGPROGRAM
		#pragma surface surf SimpleLambert //alphatest:_Cutoff 

	fixed4 _SpecularColor;
	fixed4 _LightColor;
	half4 _LightDir;
	half _Warp;
    float _Shininess;
	
    half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
    {
//		half3 h = normalize(lightDir + viewDir);
//		half NdotL = max(0, dot(s.Normal, lightDir));
		half3 h = normalize(_LightDir + viewDir);
		half NdotL = max(0, dot(s.Normal, _LightDir));
		half diff = saturate(NdotL + _Warp) / (1 + _Warp);
		
		half4 c;
		c.rgb = (s.Albedo * _LightColor.rgb * diff) * (atten * 2);
		c.rgb += _SpecularColor.rgb * s.Specular * atten;
	    c.a = s.Alpha;

	    return c;
    }

	struct Input
	{
		half2 uv_MainTex;
		float3 viewDir;
		float3 worldNormal;
	};
          
     sampler2D _MainTex;
     float4 _Color;
     float _Ambient;
	 float4 _AddColor;

     void surf (Input IN, inout SurfaceOutput o) 
     {
     	 fixed4 texColor = tex2D(_MainTex , IN.uv_MainTex) * _Color;
         o.Albedo = fixed4(0,0,0,0);//texColor.rgb + _AddColor.rgb;
         o.Emission = texColor.rgb * _Ambient + _AddColor.rgb;
         half3 reflection = normalize(reflect(_LightDir.xyz, IN.worldNormal));
		 o.Specular = saturate(dot(reflection, normalize(-IN.viewDir)));
		 o.Specular = pow(o.Specular, _Shininess);         
         o.Alpha = texColor.a;
     }
      ENDCG
    }
	FallBack "Diffuse"
}


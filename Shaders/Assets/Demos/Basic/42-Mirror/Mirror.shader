// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.27 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.27;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9361,x:33209,y:32712,varname:node_9361,prsc:2|emission-6505-RGB;n:type:ShaderForge.SFN_Tex2d,id:6505,x:32954,y:32803,ptovrint:False,ptlb:MirrorTex,ptin:_MirrorTex,varname:node_6505,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:24412233ab76bb3489929625572472bf,ntxv:0,isnm:False|UVIN-5145-OUT;n:type:ShaderForge.SFN_ScreenPos,id:3763,x:32054,y:32565,varname:node_3763,prsc:2,sctp:2;n:type:ShaderForge.SFN_ProjectionParameters,id:4928,x:32274,y:33002,varname:node_4928,prsc:2;n:type:ShaderForge.SFN_ComponentMask,id:481,x:32364,y:32841,varname:node_481,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1;n:type:ShaderForge.SFN_Append,id:6245,x:32700,y:32877,varname:node_6245,prsc:2|A-481-R,B-6774-OUT;n:type:ShaderForge.SFN_Multiply,id:3879,x:32530,y:33013,varname:node_3879,prsc:2|A-481-G,B-4928-SGN,C-1784-OUT;n:type:ShaderForge.SFN_Vector1,id:1784,x:32274,y:33165,varname:node_1784,prsc:2,v1:-1;n:type:ShaderForge.SFN_Add,id:6774,x:32740,y:33033,varname:node_6774,prsc:2|A-3879-OUT,B-8357-OUT;n:type:ShaderForge.SFN_Vector1,id:2612,x:32899,y:33349,varname:node_2612,prsc:2,v1:0;n:type:ShaderForge.SFN_Add,id:5396,x:32497,y:33202,varname:node_5396,prsc:2|A-4928-SGN,B-3510-OUT;n:type:ShaderForge.SFN_Vector1,id:3510,x:32333,y:33302,varname:node_3510,prsc:2,v1:1;n:type:ShaderForge.SFN_Divide,id:8357,x:32669,y:33230,varname:node_8357,prsc:2|A-5396-OUT,B-4681-OUT;n:type:ShaderForge.SFN_Vector1,id:4681,x:32481,y:33394,varname:node_4681,prsc:2,v1:2;n:type:ShaderForge.SFN_Append,id:5145,x:32671,y:32545,varname:node_5145,prsc:2|A-3763-U,B-3825-OUT;n:type:ShaderForge.SFN_OneMinus,id:3825,x:32328,y:32616,varname:node_3825,prsc:2|IN-3763-V;proporder:6505;pass:END;sub:END;*/

Shader "Iann/Basic/Mirror" {
    Properties {
        _MirrorTex ("Mirror Texture", 2D) = "white" {}
		_MainTex ("Main Texture", 2D) = "white" {}
		_BaseColor ("Base Color(RGB)", Color) = (0.05,0.1,0.1,1)
		_Roughness ("Roughness", Range(0,8)) = 0
		_ReflectRate ("ReflectRate", Range(0,1)) = 0.75
    }
    SubShader {
        Tags {
            "RenderType"="Transparent" "Queue"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
			//Blend One One
			Blend SrcAlpha OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _MirrorTex; uniform float4 _MirrorTex_ST;
			
			uniform float4x4 _ProjMat;
			uniform float4x4 _ViewMat;
			uniform float4 _BaseColor;
			uniform float _Roughness;
			uniform float _ReflectRate;
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv :	TEXCOORD0;
				float4 screenPos : TEXCOORD1;
				float4 screenPos2 : TEXCOORD2;
			};

			void vert(in appdata_base v, out v2f o) {
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.screenPos = mul(_ProjMat, mul(_ViewMat, mul(unity_ObjectToWorld, v.vertex)));
				o.screenPos2 = o.screenPos;
			}

			void frag(in v2f input, out float4 c : COLOR) {
				input.screenPos = float4(input.screenPos.xy / input.screenPos.w, 0, 0);
				//i.screenPos.y *= _ProjectionParams.x;
				input.screenPos = (input.screenPos + 1) / 2;
				
				float4 mainColor = tex2D(_MainTex, input.uv);
				float4 mirrorColor = tex2Dlod(_MirrorTex, float4(input.screenPos.rg,0, _Roughness));
				c = float4(mainColor.rgb*_BaseColor.rgb + mirrorColor.rgb*_ReflectRate, mirrorColor.a);
			}
            ENDCG
        }
    }
    //FallBack "Diffuse"
   //CustomEditor "ShaderForgeMaterialInspector"
}

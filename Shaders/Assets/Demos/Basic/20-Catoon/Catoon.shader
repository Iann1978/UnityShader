// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.25 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.25;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3138,x:33426,y:32402,varname:node_3138,prsc:2|emission-7014-OUT;n:type:ShaderForge.SFN_NormalVector,id:5284,x:32369,y:32575,prsc:2,pt:False;n:type:ShaderForge.SFN_ViewVector,id:1344,x:32369,y:32420,varname:node_1344,prsc:2;n:type:ShaderForge.SFN_Code,id:4158,x:32621,y:32480,varname:node_4158,prsc:2,code:ZgBsAG8AYQB0ACAAZQAgAD0AIABkAG8AdAAoAHYAaQBlAHcARABpAHIALABuAG8AcgBtAGEAbABEAGkAcgApADsACgByAGUAdAB1AHIAbgAgAGYAbABvAGEAdAAyACgAMQAtAGUALAAwAC4ANQApADsACgA=,output:1,fname:Function_node_4158,width:269,height:112,input:2,input:2,input_1_label:viewDir,input_2_label:normalDir|A-1344-OUT,B-5284-OUT;n:type:ShaderForge.SFN_Tex2d,id:5802,x:33033,y:32461,ptovrint:False,ptlb:Grade,ptin:_Grade,varname:_Base_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:229b865c2424efd47ac08b723bd39acc,ntxv:0,isnm:False|UVIN-4158-OUT;n:type:ShaderForge.SFN_Tex2d,id:2870,x:33000,y:32715,ptovrint:False,ptlb:Base,ptin:_Base,varname:node_2870,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0d7c41628f1a84e459a217a0c3f89425,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:7014,x:33251,y:32383,varname:node_7014,prsc:2|A-5802-RGB,B-2870-RGB;proporder:5802-2870;pass:END;sub:END;*/

Shader "Shader Forge/Catoon" {
    Properties {
        _Grade ("Grade", 2D) = "white" {}
        _Base ("Base", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            float2 Function_node_4158( float3 viewDir , float3 normalDir ){
            float e = dot(viewDir,normalDir);
            return float2(1-e,0.5);
            
            }
            
            uniform sampler2D _Grade; uniform float4 _Grade_ST;
            uniform sampler2D _Base; uniform float4 _Base_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float2 node_4158 = Function_node_4158( viewDirection , i.normalDir );
                float4 _Grade_var = tex2D(_Grade,TRANSFORM_TEX(node_4158, _Grade));
                float4 _Base_var = tex2D(_Base,TRANSFORM_TEX(i.uv0, _Base));
                float3 emissive = (_Grade_var.rgb*_Base_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

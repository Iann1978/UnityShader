// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.25 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.25;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1,x:34567,y:32632,varname:node_1,prsc:2|emission-59-OUT;n:type:ShaderForge.SFN_NormalVector,id:2,x:33429,y:32734,prsc:2,pt:False;n:type:ShaderForge.SFN_ViewVector,id:3,x:33429,y:32883,varname:node_3,prsc:2;n:type:ShaderForge.SFN_Code,id:4,x:33654,y:32957,varname:node_4,prsc:2,code:ZgBsAG8AYQB0ACAAcgBpAG0AIAA9ACAAMQAuADAAIAAtACAAcwBhAHQAdQByAGEAdABlACgAZABvAHQAKABOAG8AcgBtAGEAbABEAGkAcgAsAFYAaQBlAHcARABpAHIAKQApADsACgByAGUAdAB1AHIAbgAgAFIAaQBtAEMAbwBsAG8AcgAgACoAIABwAG8AdwAoAHIAaQBtACwAUgBpAG0AUABvAHcAZQByACkAOwA=,output:2,fname:Rim,width:392,height:128,input:2,input:2,input:2,input:0,input_1_label:NormalDir,input_2_label:ViewDir,input_3_label:RimColor,input_4_label:RimPower|A-2-OUT,B-3-OUT,C-5-RGB,D-67-OUT;n:type:ShaderForge.SFN_Color,id:5,x:33113,y:32972,ptovrint:False,ptlb:RimColor,ptin:_RimColor,varname:node_1143,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:6,x:32984,y:33196,ptovrint:False,ptlb:RimPower,ptin:_RimPower,varname:node_3452,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_Tex2d,id:7,x:33514,y:32315,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:node_7508,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:57,x:33514,y:32601,ptovrint:False,ptlb:Emission,ptin:_Emission,varname:node_1372,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_Multiply,id:58,x:33717,y:32601,varname:node_58,prsc:2|A-7-RGB,B-57-OUT;n:type:ShaderForge.SFN_Add,id:59,x:34371,y:32726,varname:node_59,prsc:2|A-58-OUT,B-1317-OUT;n:type:ShaderForge.SFN_Clamp,id:67,x:33403,y:33082,varname:node_67,prsc:2|IN-6-OUT,MIN-68-OUT,MAX-69-OUT;n:type:ShaderForge.SFN_Vector1,id:68,x:32984,y:33295,varname:node_68,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:69,x:32984,y:33378,varname:node_69,prsc:2,v1:3;n:type:ShaderForge.SFN_Multiply,id:1317,x:34123,y:33129,varname:node_1317,prsc:2|A-4-OUT,B-3122-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3122,x:33638,y:33288,ptovrint:False,ptlb:RimParam,ptin:_RimParam,varname:_Emission_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;proporder:5-6-7-57-3122;pass:END;sub:END;*/

Shader "Shader Forge/Rim" {
    Properties {
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimPower ("RimPower", Float ) = 3
        _Diffuse ("Diffuse", 2D) = "white" {}
        _Emission ("Emission", Float ) = 0.1
        _RimParam ("RimParam", Float ) = 0.1
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
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 ps3 
            #pragma target 3.0
            float3 Rim( float3 NormalDir , float3 ViewDir , float3 RimColor , float RimPower ){
            float rim = 1.0 - saturate(dot(NormalDir,ViewDir));
            return RimColor * pow(rim,RimPower);
            }
            
            uniform float4 _RimColor;
            uniform float _RimPower;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _Emission;
            uniform float _RimParam;
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
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 emissive = ((_Diffuse_var.rgb*_Emission)+(Rim( i.normalDir , viewDirection , _RimColor.rgb , clamp(_RimPower,0.0,3.0) )*_RimParam));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

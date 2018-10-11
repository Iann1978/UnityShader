// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.25 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.25;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3138,x:33253,y:32674,varname:node_3138,prsc:2|emission-6035-OUT;n:type:ShaderForge.SFN_NormalVector,id:8791,x:31902,y:32905,prsc:2,pt:False;n:type:ShaderForge.SFN_ViewVector,id:1827,x:31902,y:32708,varname:node_1827,prsc:2;n:type:ShaderForge.SFN_Code,id:6113,x:32321,y:32791,varname:node_6113,prsc:2,code:ZgBsAG8AYQB0ACAAZABvAHQAVgBOACAAPQAgAGQAbwB0ACgAdgBpAGUAdwBEAGkAcgAsAG4AbwByAG0AYQBsAEQAaQByACkAOwAKAGYAbABvAGEAdAAgAGUAIAA9ACAAMQAtAGQAbwB0AFYATgA7AAoAcgBlAHQAdQByAG4AIABlACAAKgAgAGMAbwBsAG8AcgA7AAoA,output:2,fname:FuncForXRay,width:517,height:278,input:2,input:2,input:2,input_1_label:viewDir,input_2_label:normalDir,input_3_label:color|A-1827-OUT,B-8791-OUT,C-6409-RGB;n:type:ShaderForge.SFN_Color,id:6409,x:31902,y:33127,ptovrint:False,ptlb:XColor,ptin:_XColor,varname:node_6409,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:5241,x:32736,y:33147,ptovrint:False,ptlb:node_5241,ptin:_node_5241,varname:node_5241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0d7c41628f1a84e459a217a0c3f89425,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:6035,x:32977,y:32828,varname:node_6035,prsc:2|A-6113-OUT,B-5241-RGB;proporder:6409-5241;pass:END;sub:END;*/

Shader "Shader Forge/XRay" {
    Properties {
        _XColor ("XColor", Color) = (0.5,0.5,0.5,1)
        _node_5241 ("node_5241", 2D) = "white" {}
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
            float3 FuncForXRay( float3 viewDir , float3 normalDir , float3 color ){
            float dotVN = dot(viewDir,normalDir);
            float e = 1-dotVN;
            return e * color;
            
            }
            
            uniform float4 _XColor;
            uniform sampler2D _node_5241; uniform float4 _node_5241_ST;
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
                float3 node_6113 = FuncForXRay( viewDirection , i.normalDir , _XColor.rgb );
                float4 _node_5241_var = tex2D(_node_5241,TRANSFORM_TEX(i.uv0, _node_5241));
                float3 emissive = (node_6113+_node_5241_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

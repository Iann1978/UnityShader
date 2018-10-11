
#pragma target 5.0
#include "UnityCG.cginc"
#include "Lighting.cginc"

sampler2D _Normal; float4 _Normal_ST;
sampler2D _Albedo; float4 _Albedo_ST;
float _FurThickness; 


struct v2f {
	float4 pos : SV_POSITION;
	float2 texcoord : TEXCOORD0;
	//float3 normal : NORMAL;
};

void vert(in appdata_tan input, out v2f output)
{
	float3 tangentDir = normalize(input.tangent.xyz);
	float3 normalDir = normalize(input.normal);
	float3 binormalDir = normalize(cross(tangentDir, normalDir));
	//tex2D(_Normal, input.texcoord);
	// float3 mm = ;
	// float4 nn = float4(mm,1);
	float3 normalDirInTangent = normalize(UnpackNormal(tex2Dlod( _Normal, float4(input.texcoord.xy, 0,0))));
	float3 normal = normalize(normalDirInTangent.x * tangentDir + normalDirInTangent.y * binormalDir + normalDirInTangent.z * normalDir);

	//input.normal = normalize(normal);
	input.vertex /= input.vertex.w;
	input.vertex.xyz += _FurThickness * LAYER_PARAM * normal;
	output.pos = UnityObjectToClipPos(input.vertex);
	output.texcoord = input.texcoord;
}

void frag(in v2f input, out float4 c : COLOR)
{

	c = tex2D(_Albedo, input.texcoord);
	c = tex2D(_Albedo, TRANSFORM_TEX(input.texcoord, _Albedo));
	if (c.a < LAYER_PARAM)
		discard;
	//c.a = 1;
}
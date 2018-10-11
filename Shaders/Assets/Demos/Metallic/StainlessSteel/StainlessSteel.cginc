float _Diffuse, _Specular;
float _Gloss;
float _AnisoX, _AnisoY, _AnisoAngle, _AnisoIntensity;
sampler2D _AnisoTexture; float4 _AnisoTexture_ST;

struct v2f
{
	float4 pos : SV_POSITION;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 worldPos : TEXCOORD0;
	float2 texcoord : TEXCOORD1;
	LIGHTING_COORDS(3, 4)
};

void vert(in appdata_tan v, out v2f output)
{
	output.pos = UnityObjectToClipPos(v.vertex);
	output.normal = v.normal;
	output.tangent = v.tangent;
	output.worldPos = mul(unity_ObjectToWorld, v.vertex);
	output.worldPos /= output.worldPos.w;
	output.texcoord = v.texcoord;
	TRANSFER_VERTEX_TO_FRAGMENT(output);
}

void frag(in v2f input, out float4 c : COLOR)
{
	c.rgb = 0;
	

	
	float3 lightColor = _LightColor0.rgb;
	float3 vertPos = input.worldPos.xyz;
	float3 lightPos = _WorldSpaceLightPos0.xyz;
	float3 normalDir = normalize(UnityObjectToWorldNormal(input.normal));
	float3 tangentDir = normalize(UnityObjectToWorldNormal(input.tangent));
	float3 bitangentDir = normalize(cross(tangentDir, normalDir));
	float3 anisoDir = normalize(UnpackNormal(tex2D(_AnisoTexture, input.texcoord)));
	float3 lightDir = lightPos - vertPos;
	if (_WorldSpaceLightPos0.w<0.001) lightDir = lightPos;
	float3 b = bitangentDir;
	float3 t = tangentDir;
	float3 n = normalDir;
	//if (anisoDir.z<0.99)
	{
		float Pi = 3.141592654;
		float3 anisoParam = tex2D(_AnisoTexture, TRANSFORM_TEX(input.texcoord, _AnisoTexture));
		_AnisoX = anisoParam.r;
		_AnisoY = anisoParam.g;
		_AnisoAngle = anisoParam.b * 180;

		//t = normalize(anisoDir.x * tangentDir + anisoDir.y * bitangentDir);
		t = t * cos(_AnisoAngle*Pi/180) + b * sin(_AnisoAngle*Pi/180);
		n = normalDir;
		b = normalize(cross(t,n));
	}
	float3 l = normalize(lightDir);
	float3 v = normalize(_WorldSpaceCameraPos.xyz - vertPos);				
	float3 h = normalize(l+v);				
	float3 dotLN = saturate(dot(l,n));
	float3 dotHN = saturate(dot(h,n));
	float3 dotHT = (dot(h,t));
	float3 dotHB = (dot(h,b));
	float3 dotVN = max(0.01,dot(v,n));

	// attenuate
	float attenuation = LIGHT_ATTENUATION(input);

	// diffuse
	float3 diffuse = dotLN * lightColor * _Diffuse;

	// specular
	float3 specular = pow(dotHN, _Gloss*256) * _Specular * lightColor;
	specular = _Specular * lightColor *  sqrt(dotLN/dotVN) * exp(-2 * (dotHT*dotHT/_AnisoX/_AnisoX + dotHB*dotHB/_AnisoY/_AnisoY)/(1+dotHN));

	// reflect 
	float3 rv = reflect(-v, n);
	rv -= t * dot(rv,t);
	float3 refl = 0;
	for (int i=0; i<0; i++) {
		float3 drv = rv + t*i*0.02;
		refl += UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, drv, 0);
		drv = rv -t*i*0.02;
		refl += UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, drv, 0);
	}
	refl /= 10;
	//refl =  UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflect(-v, n), 0);
	
	//refl = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rv, 0);


	c.rgb = attenuation * (diffuse + specular);
	#ifdef UNITY_PASS_FORWARDBASE
	c.rgb += refl*0.2;
	
	#endif
	//c.rgb = attenuation;
	//c.rgb = sqrt(dotLN/dotVN)/10;
	//c.rgb = 0;

	//c.rgb = specular;
	//c.rgb = 0;
	c.a = 0;
}
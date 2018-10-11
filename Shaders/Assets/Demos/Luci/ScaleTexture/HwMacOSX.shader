Shader "Custom/HwMacOSX"
{
	Properties 
	{
		_YTex ("Texture Y", 2D) = "white" {}
		_UVTex ("Texture UV", 2D) = "gray" {}
		_Size ("Video size (in xy)", Vector) = (0.0, 0.0, 0.0, 0.0)
		_Brightness ("Brightness", float) = 0.8
		_Eyeindex ("Eyeindex", int) = 0
	}

	SubShader
	{
		Pass
		{
			GLSLPROGRAM

				#ifdef VERTEX

				uniform vec4 _Size;
				uniform int _Eyeindex;
				varying vec2 uv;
				
				void main()
				{
					//uv = gl_MultiTexCoord0.xy * _Size.xy;
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
					if (_Eyeindex == 0)
                        uv = gl_MultiTexCoord0.xy * _Size.xy;
                    else
                        uv = gl_MultiTexCoord1.xy * _Size.xy;
				}

				#endif



				#ifdef FRAGMENT

				uniform sampler2DRect _YTex;
				uniform sampler2DRect _UVTex;
				uniform float _Brightness;
				varying vec2 uv;
				const vec3 r_c = vec3(1.164383,  0.000000,  1.596027);
				const vec3 g_c = vec3(1.164383, -0.391762, -0.812968);
				const vec3 b_c = vec3(1.164383,  2.017232,  0.000000);
				const vec3 offset = vec3(-0.0625, -0.5, -0.5);
				void main()
				{
				    vec3 yuv = vec3(texture(_YTex , uv).r, texture(_UVTex, uv * 0.5).rg) + offset;
					gl_FragColor = vec4(dot(yuv, r_c), dot(yuv, g_c), dot(yuv, b_c), 1.0) * _Brightness;
					//gl_FragColor=vec4(1,1,0,1);
				}

				#endif
				

			ENDGLSL
		}
	}

	FallBack "Unlit/Texture"
}

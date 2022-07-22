// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PP2"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_DepthIntensity("DepthIntensity", Range( 0 , 1)) = 0.04
		_Intensity("Intensity", Range( 0 , 1)) = 0

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Intensity;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthIntensity;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord47 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _OriginalResolution = float2(1920,1080);
				float temp_output_52_0 = ( 1.0 - (0.9 + (_Intensity - 0.0) * (0.99 - 0.9) / (1.0 - 0.0)) );
				float pixelWidth46 =  1.0f / ( _OriginalResolution.x * temp_output_52_0 );
				float pixelHeight46 = 1.0f / ( _OriginalResolution.y * temp_output_52_0 );
				half2 pixelateduv46 = half2((int)(texCoord47.x / pixelWidth46) * pixelWidth46, (int)(texCoord47.y / pixelHeight46) * pixelHeight46);
				float4 color9 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth1 = (SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy )*( _ProjectionParams.z - _ProjectionParams.y ));
				float4 lerpResult7 = lerp( tex2D( _MainTex, pixelateduv46 ) , color9 , saturate( ( 1.0 - ( eyeDepth1 * _DepthIntensity ) ) ));
				

				finalColor = lerpResult7;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
8;81;1394;950;1472.1;867.1363;1.337062;True;False
Node;AmplifyShaderEditor.RangedFloatNode;51;-2146.462,-249.467;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;53;-1791.199,-249.2509;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.9;False;4;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1102.067,92.00012;Inherit;False;835.0001;264.523;Darkness fog;5;5;1;4;6;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1052.067,240.5232;Inherit;False;Property;_DepthIntensity;DepthIntensity;0;0;Create;True;0;0;0;False;0;False;0.04;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;1;-963.8484,142.0002;Inherit;False;0;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;50;-1697.426,-444.8283;Inherit;False;Constant;_OriginalResolution;OriginalResolution;1;0;Create;True;0;0;0;False;0;False;1920,1080;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;52;-1555.817,-237.8948;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1300.426,-257.8283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-712.0662,168.4232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-1428.426,-557.8281;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1307.426,-401.8283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;46;-956.4052,-412.5272;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;10;-575.0297,164.8056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-702.0699,-441.2963;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;6;-432.066,150.4232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-484.9129,-186.068;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-1985.265,-902.3092;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-1773.048,-909.2836;Inherit;True;Property;_ScreenTexture;ScreenTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-96.04271,-236.8587;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;119.6375,-236.0813;Float;False;True;-1;2;ASEMaterialInspector;0;2;PP2;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;53;0;51;0
WireConnection;52;0;53;0
WireConnection;49;0;50;2
WireConnection;49;1;52;0
WireConnection;4;0;1;0
WireConnection;4;1;5;0
WireConnection;48;0;50;1
WireConnection;48;1;52;0
WireConnection;46;0;47;0
WireConnection;46;1;48;0
WireConnection;46;2;49;0
WireConnection;10;0;4;0
WireConnection;43;1;46;0
WireConnection;6;0;10;0
WireConnection;32;0;2;0
WireConnection;7;0;43;0
WireConnection;7;1;9;0
WireConnection;7;2;6;0
WireConnection;0;0;7;0
ASEEND*/
//CHKSM=E7D7404B9158F2FE6C702A19E0458AA72EADE499
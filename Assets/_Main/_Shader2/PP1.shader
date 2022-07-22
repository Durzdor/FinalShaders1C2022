// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PP1"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Distortion("Distortion", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _Distortion;
			uniform float4 _Distortion_ST;
			uniform float _Intensity;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv_Distortion = i.uv.xy * _Distortion_ST.xy + _Distortion_ST.zw;
				float4 lerpResult8 = lerp( float4( uv_MainTex, 0.0 , 0.0 ) , tex2D( _Distortion, uv_Distortion ) , _Intensity);
				float2 panner10 = ( 0.0 * float2( -1,1 ) + lerpResult8.rg);
				

				finalColor = tex2D( _MainTex, panner10 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
8;81;1394;950;2077.654;1010.119;2.2;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;4;-1326.7,-262.7061;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1203.733,-30.8686;Inherit;True;Property;_Distortion;Distortion;0;0;Create;True;0;0;0;False;0;False;-1;e3ad966b7fa4d2d4499ef60af9adbaaa;e3ad966b7fa4d2d4499ef60af9adbaaa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1132.162,-160.4383;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1194.278,182.4179;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-720.9141,384.8677;Inherit;False;Constant;_DistortionSpeed;DistortionSpeed;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-801.1335,-77.43409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;11;-773.6832,204.19;Inherit;False;Constant;_DistortionDirection;DistortionDirection;4;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-425.8609,-75.4669;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;30.66981,543.1851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;24;-59.22511,371.6728;Inherit;False;0;8;2;1,0,0,0;1,0.1764706,0,0.1499962;1,0.372549,0,0.3000076;1,0.5686275,0,0.4500038;1,0.7647059,0,0.6;1,0.9607843,0,0.7499962;1,1,0.1568628,0.9000076;1,1,0.3529412,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-282.5138,615.2391;Inherit;False;Property;_DepthIntensity;DepthIntensity;2;0;Create;True;0;0;0;False;0;False;0.3441055;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;210.627,543.3231;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;411.4831,345.5278;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;13;-199.7036,519.3568;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-143.0239,-260.4085;Inherit;True;Property;_ScreenDefault;ScreenDefault;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;33;672.3729,-261.0744;Float;False;True;-1;2;ASEMaterialInspector;0;2;PP1;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;2;4;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;9;0
WireConnection;10;0;8;0
WireConnection;10;2;11;0
WireConnection;10;1;12;0
WireConnection;15;0;13;0
WireConnection;16;0;15;0
WireConnection;17;1;24;0
WireConnection;17;2;16;0
WireConnection;5;0;4;0
WireConnection;5;1;10;0
WireConnection;33;0;5;0
ASEEND*/
//CHKSM=25E8E56E818823CA059F7629FC74C0396B738341
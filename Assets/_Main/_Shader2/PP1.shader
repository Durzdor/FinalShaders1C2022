// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PP1"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Distortion("Distortion", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0
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
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"


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
			
			uniform float _Intensity;
			uniform sampler2D _Distortion;
			uniform float4 _Distortion_ST;
			uniform sampler2D _TextureSample1;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


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
				float MainIntensity120 = _Intensity;
				float2 texCoord122 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord6 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_Distortion = i.uv.xy * _Distortion_ST.xy + _Distortion_ST.zw;
				float mulTime49 = _Time.y * ( MainIntensity120 == 0.0 ? 0.0 : log( 1.5 ) );
				float temp_output_57_0 = (0.0 + (sin( mulTime49 ) - -1.0) * (0.01 - 0.0) / (1.0 - -1.0));
				float temp_output_78_0 = (0.0 + (temp_output_57_0 - 0.0) * (10.0 - 0.0) / (0.01 - 0.0));
				float IntensitySinRemap97 = (0.0 + (temp_output_78_0 - 0.0) * (1.0 - 0.0) / (10.0 - 0.0));
				float4 lerpResult8 = lerp( float4( texCoord6, 0.0 , 0.0 ) , tex2D( _Distortion, uv_Distortion ) , (0.0 + (IntensitySinRemap97 - 0.0) * (0.45 - 0.0) / (1.0 - 0.0)));
				float2 panner10 = ( 0.1 * float2( -1,1 ) + lerpResult8.rg);
				float4 TextureDefault62 = tex2D( _MainTex, ( MainIntensity120 == 0.0 ? texCoord122 : panner10 ) );
				float4 color47 = IsGammaSpace() ? float4(0.09411765,0,1,0) : float4(0.009134057,0,1,0);
				float4 RingsColor60 = ( color47 * 1.0 );
				float2 texCoord129 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime66 = _Time.y * 0.1;
				float2 texCoord50 = i.uv.xy * float2( 1,1 ) + float2( -0.5,-0.5 );
				float simplePerlin2D76 = snoise( texCoord50*temp_output_57_0 );
				simplePerlin2D76 = simplePerlin2D76*0.5 + 0.5;
				float2 appendResult73 = (float2(simplePerlin2D76 , simplePerlin2D76));
				float2 temp_cast_2 = (length( texCoord50 )).xx;
				float2 panner54 = ( mulTime66 * appendResult73 + temp_cast_2);
				float simplePerlin2D48 = snoise( UnpackScaleNormal( tex2D( _TextureSample1, ( MainIntensity120 == 0.0 ? texCoord129 : panner54 ) ), 0.1 ).xy*temp_output_78_0 );
				simplePerlin2D48 = simplePerlin2D48*0.5 + 0.5;
				float CircleNoise58 = ( ( simplePerlin2D48 * IntensitySinRemap97 ) * ( MainIntensity120 == 0.0 ? 0.0 : 1.0 ) );
				float4 lerpResult45 = lerp( TextureDefault62 , RingsColor60 , CircleNoise58);
				

				finalColor = lerpResult45;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
8;81;1394;950;3162.875;1731.307;1.843706;True;False
Node;AmplifyShaderEditor.RangedFloatNode;115;-2092.896,-692.7062;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-1809.197,-694.0602;Inherit;False;MainIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-4345.321,12.80259;Inherit;False;Constant;_Float3;Float 1;5;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-4325.393,-156.8675;Inherit;False;120;MainIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LogOpNode;104;-4186.986,18.28698;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-4268.309,-70.81907;Inherit;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;126;-4028.39,-156.8675;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;49;-3840.775,-150.6335;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;56;-3661,-149.1112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-3527.249,-153.7577;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;52;-3809.558,-542.4979;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;-0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;78;-2400.297,-162.72;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-3592.373,-584.0452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;76;-3299.428,-482.3582;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;96;-2074.464,-168.6108;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-3190.312,-225.9809;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1889.948,-171.2418;Inherit;False;IntensitySinRemap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-3007.312,-283.9809;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-3002.938,-438.2112;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;51;-3256.946,-590.9752;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-2855.328,-759.402;Inherit;False;120;MainIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2508.948,-1345.242;Inherit;False;97;IntensitySinRemap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-2937.328,-629.402;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;54;-2777.671,-473.5256;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Compare;128;-2557.209,-599.6062;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-2410.048,-1643.18;Inherit;True;Property;_Distortion;Distortion;0;0;Create;True;0;0;0;False;0;False;-1;e3ad966b7fa4d2d4499ef60af9adbaaa;e3ad966b7fa4d2d4499ef60af9adbaaa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;99;-2266.948,-1339.242;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.45;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2338.477,-1772.75;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-2564.427,-333.6101;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-2000.553,-1662.16;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;11;-2020.705,-1465.257;Inherit;False;Constant;_DistortionDirection;DistortionDirection;4;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;12;-2025.86,-1307.111;Inherit;False;Constant;_DistortionSpeed;DistortionSpeed;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-2394.604,-500.3789;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;e06c2131c4652234c9b77ee97cfcca75;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-2042.827,-501.019;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-1713.081,-1450.674;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-1730.529,-1259.463;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1700.85,-1558.723;Inherit;False;120;MainIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;124;-1518.095,-695.2069;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;119;-1442.697,-1454.538;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1634.324,-498.8864;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;4;-1457.384,-1568.979;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1470.837,-27.08548;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;-1534.797,-219.0198;Inherit;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.09411765,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-1318.118,-498.8579;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1261.796,-1490.413;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1283.525,-155.4947;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-989.6813,-503.8987;Inherit;False;CircleNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-803.8704,-1488.608;Inherit;False;TextureDefault;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1116.378,-161.155;Inherit;False;RingsColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-362.8487,-904.8529;Inherit;False;58;CircleNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-358.3651,-1010.236;Inherit;False;60;RingsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-382.1611,-1115.568;Inherit;False;62;TextureDefault;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;45;-66.90784,-1056.522;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;33;181.7507,-1057.107;Float;False;True;-1;2;ASEMaterialInspector;0;2;PP1;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;132;-2066.115,-980.8572;Inherit;False;569.6234;235.2166;Trate de hacer que solo funcione cuando yo le digo pero no se como hacerlo;1;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;125;-1432.29,-1300.935;Inherit;False;109.1;100;Turn On/Off;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;-1308.22,-585.8057;Inherit;False;165.3049;101.4842;Turn On/Off  0-1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-2049.469,-912.365;Inherit;False;544.9064;100;Para que cuando se active por primera vez no vaya por la mitad del efecto;0;;1,1,1,1;0;0
WireConnection;120;0;115;0
WireConnection;104;0;103;0
WireConnection;126;0;127;0
WireConnection;126;2;131;0
WireConnection;126;3;104;0
WireConnection;49;0;126;0
WireConnection;56;0;49;0
WireConnection;57;0;56;0
WireConnection;78;0;57;0
WireConnection;50;1;52;0
WireConnection;76;0;50;0
WireConnection;76;1;57;0
WireConnection;96;0;78;0
WireConnection;97;0;96;0
WireConnection;66;0;64;0
WireConnection;73;0;76;0
WireConnection;73;1;76;0
WireConnection;51;0;50;0
WireConnection;54;0;51;0
WireConnection;54;2;73;0
WireConnection;54;1;66;0
WireConnection;128;0;130;0
WireConnection;128;2;129;0
WireConnection;128;3;54;0
WireConnection;99;0;98;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;99;0
WireConnection;46;1;128;0
WireConnection;46;5;53;0
WireConnection;48;0;46;0
WireConnection;48;1;78;0
WireConnection;10;0;8;0
WireConnection;10;2;11;0
WireConnection;10;1;12;0
WireConnection;124;0;120;0
WireConnection;119;0;121;0
WireConnection;119;2;122;0
WireConnection;119;3;10;0
WireConnection;85;0;48;0
WireConnection;85;1;97;0
WireConnection;116;0;85;0
WireConnection;116;1;124;0
WireConnection;36;0;4;0
WireConnection;36;1;119;0
WireConnection;68;0;47;0
WireConnection;68;1;69;0
WireConnection;58;0;116;0
WireConnection;62;0;36;0
WireConnection;60;0;68;0
WireConnection;45;0;63;0
WireConnection;45;1;61;0
WireConnection;45;2;59;0
WireConnection;33;0;45;0
ASEEND*/
//CHKSM=2D138869AB435085FB9D78AC8C82DAF6C48365A8
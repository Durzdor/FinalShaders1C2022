// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Portal"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "bump" {}
		_DistortionScale("DistortionScale", Range( 0 , 0.1)) = 0
		_BorderWidth("BorderWidth", Range( 0.4 , 0.6)) = 0.35
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _TextureSample4;
		uniform float _DistortionScale;
		uniform sampler2D _TextureSample1;
		uniform float _BorderWidth;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime39 = _Time.y * 0.3;
			float2 temp_output_26_0 = (float2( -1,-1 ) + (i.uv_texcoord - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
			float2 break28 = temp_output_26_0;
			float2 appendResult34 = (float2(length( temp_output_26_0 ) , ( atan2( break28.x , break28.y ) / ( 2.0 * UNITY_PI ) )));
			float2 UVAngular36 = appendResult34;
			float2 panner35 = ( mulTime39 * float2( 0,1 ) + UVAngular36);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor43 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( UnpackScaleNormal( tex2D( _TextureSample4, panner35 ), _DistortionScale ) , 0.0 ) + ase_grabScreenPosNorm ).xy);
			float4 Distortion48 = ( screenColor43 * 0.5 );
			float temp_output_136_0 = (0.0 + (sin( _Time.y ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float2 appendResult148 = (float2(-( temp_output_136_0 / 50.0 ) , ( temp_output_136_0 / 50.0 )));
			float2 panner137 = ( temp_output_136_0 * appendResult148 + i.uv_texcoord);
			float4 color123 = IsGammaSpace() ? float4(1,0.4559605,0,0) : float4(1,0.1755188,0,0);
			float2 uv_TexCoord49 = i.uv_texcoord + float2( -0.5,-0.5 );
			float temp_output_50_0 = length( uv_TexCoord49 );
			float temp_output_98_0 = ceil( ( ( 1.0 - temp_output_50_0 ) - 0.4 ) );
			float PortalBorderMask120 = ( temp_output_98_0 * ceil( ( temp_output_50_0 - _BorderWidth ) ) );
			float4 lerpResult131 = lerp( tex2D( _TextureSample1, panner137 ) , color123 , PortalBorderMask120);
			o.Emission = saturate( ( Distortion48 + lerpResult131 ) ).rgb;
			float PortalShapeOpacity55 = temp_output_98_0;
			o.Alpha = PortalShapeOpacity55;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
12;81;1394;950;1298.528;476.9584;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;99;-1294.714,-1338.374;Inherit;False;1773.528;496.8068;Cambio a coordenadas polares para que se maneje de manera angular en vez de lineal;10;28;36;34;30;25;29;162;163;33;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1257.274,-1245.549;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;26;-984.4544,-1241.558;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-699.9673,-1130.075;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;162;-570.4479,-981.769;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;163;-395.185,-977.0496;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;29;-442.4232,-1131.296;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-147.221,-1139.079;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;33;-449.4202,-1233.874;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;101;557.5483,-237.0136;Inherit;False;1658.204;577.4053;Manipula de manera circular el uv para que tenga forma de portal;12;116;119;118;117;55;98;52;51;60;50;49;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;4.787894,-1234.897;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;156;-1942.673,-195.0336;Inherit;False;1174.9;556.4427;Vaiven de la render texture;10;135;134;136;146;154;153;155;138;148;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;100;-1045.656,-725.3857;Inherit;False;1109.356;389.6271;Agrega movimiento para formar una espiral;7;38;39;40;37;42;35;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;59;607.5483,-128.2509;Inherit;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;0;False;0;False;-0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;216.9129,-1239.053;Inherit;False;UVAngular;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-995.6562,-464.2852;Inherit;False;Constant;_Frequency;Frequency;5;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;821.6704,-173.5566;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;135;-1892.673,157.4091;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;134;-1713.673,155.4091;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;50;1065.119,-174.4408;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-818.6562,-459.2852;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-861.9755,-675.3857;Inherit;False;36;UVAngular;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;40;-832.6562,-581.2853;Inherit;False;Constant;_Direction;Direction;5;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;136;-1573.673,154.4091;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;1235.033,-183.0377;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1228.5,57.24418;Inherit;False;Constant;_BorderReduction;BorderReduction;7;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;35;-546.4509,-599.7314;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;116;1172.52,163.7457;Inherit;False;Property;_BorderWidth;BorderWidth;3;0;Create;True;0;0;0;False;0;False;0.35;0.55;0.4;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1623.24,48.13779;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-583.2155,-451.7585;Inherit;False;Property;_DistortionScale;DistortionScale;2;0;Create;True;0;0;0;False;0;False;0;0.1;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-256.3,-621.8629;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;e06c2131c4652234c9b77ee97cfcca75;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;154;-1408.629,-9.530443;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;117;1493.154,95.51729;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;44;-109.807,-396.5369;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;1499.544,-183.3929;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;153;-1385.929,93.66956;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;128.5852,-617.0924;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CeilOpNode;98;1751.515,-182.4762;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;155;-1301.329,8.369555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;118;1745.125,96.43399;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;352.1854,-435.0926;Inherit;False;Constant;_DistortionIntensity;DistortionIntensity;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;1980.094,72.27841;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;-1182.928,57.56954;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-1311.505,-145.0336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;43;315.7855,-622.2923;Inherit;False;Global;_GrabScreen0;Grab Screen 0;7;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;613.4854,-618.3925;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;137;-972.7731,53.30909;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;2245.591,66.1823;Inherit;False;PortalBorderMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-527.6265,404.2124;Inherit;False;120;PortalBorderMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;807.3478,-623.9861;Inherit;False;Distortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-585.5411,23.73074;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;f2b2095ee8b74f34ca4ef7d76e848b78;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;123;-528.8636,215.16;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;1,0.4559605,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;-420.8526,-85.22885;Inherit;False;48;Distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;131;-231.2802,80.62128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;1962.85,-187.0136;Inherit;False;PortalShapeOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-33.76837,-79.15955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;37.24887,95.51933;Inherit;False;55;PortalShapeOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;129;108.7198,-77.37872;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;330.7008,-124.6144;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Portal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;28;0;26;0
WireConnection;163;0;162;0
WireConnection;29;0;28;0
WireConnection;29;1;28;1
WireConnection;30;0;29;0
WireConnection;30;1;163;0
WireConnection;33;0;26;0
WireConnection;34;0;33;0
WireConnection;34;1;30;0
WireConnection;36;0;34;0
WireConnection;49;1;59;0
WireConnection;134;0;135;0
WireConnection;50;0;49;0
WireConnection;39;0;38;0
WireConnection;136;0;134;0
WireConnection;51;0;50;0
WireConnection;35;0;37;0
WireConnection;35;2;40;0
WireConnection;35;1;39;0
WireConnection;41;1;35;0
WireConnection;41;5;42;0
WireConnection;154;0;136;0
WireConnection;154;1;146;0
WireConnection;117;0;50;0
WireConnection;117;1;116;0
WireConnection;52;0;51;0
WireConnection;52;1;60;0
WireConnection;153;0;136;0
WireConnection;153;1;146;0
WireConnection;45;0;41;0
WireConnection;45;1;44;0
WireConnection;98;0;52;0
WireConnection;155;0;154;0
WireConnection;118;0;117;0
WireConnection;119;0;98;0
WireConnection;119;1;118;0
WireConnection;148;0;155;0
WireConnection;148;1;153;0
WireConnection;43;0;45;0
WireConnection;47;0;43;0
WireConnection;47;1;46;0
WireConnection;137;0;138;0
WireConnection;137;2;148;0
WireConnection;137;1;136;0
WireConnection;120;0;119;0
WireConnection;48;0;47;0
WireConnection;7;1;137;0
WireConnection;131;0;7;0
WireConnection;131;1;123;0
WireConnection;131;2;102;0
WireConnection;55;0;98;0
WireConnection;69;0;56;0
WireConnection;69;1;131;0
WireConnection;129;0;69;0
WireConnection;0;2;129;0
WireConnection;0;9;64;0
ASEEND*/
//CHKSM=418FE5C83AC57864B186373D54EE8DD50915FF96
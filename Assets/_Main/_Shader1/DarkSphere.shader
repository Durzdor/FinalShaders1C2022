// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DarkSphere"
{
	Properties
	{
		_GeneralOpacity("GeneralOpacity", Range( 0 , 1)) = 0.2
		_NoiseIntensity("NoiseIntensity", Range( 0 , 1)) = 6.917244
		_NoiseScale("NoiseScale", Range( 0 , 10)) = 2
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_FlowmapDistortion("FlowmapDistortion", Range( 0 , 1)) = 0.7528376
		_Depth("Depth", Float) = 1
		_DepthFalloff("DepthFalloff", Float) = 1
		_DepthScale("DepthScale", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _FlowmapDistortion;
		uniform float _NoiseScale;
		uniform float _NoiseIntensity;
		uniform sampler2D _TextureSample0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _DepthScale;
		uniform float _DepthFalloff;
		uniform float _GeneralOpacity;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 LocalVertexOffset346 = ( (0.0 + (sin( ( _Time.y + ( ase_vertex3Pos.x * 1.0 ) ) ) - -1.0) * (0.1 - 0.0) / (1.0 - -1.0)) * float3(0,1,0) * 0.5 );
			v.vertex.xyz += LocalVertexOffset346;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color231 = IsGammaSpace() ? float4(0.206435,0,0.7075472,0) : float4(0.03514528,0,0.4588115,0);
			float4 color232 = IsGammaSpace() ? float4(0.2044826,0.007843141,0.282353,0) : float4(0.03451866,0.0006070543,0.06480331,0);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 lerpResult261 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _TextureSample1, uv_TextureSample1 ) , _FlowmapDistortion);
			float2 panner229 = ( 1.0 * _Time.y * float2( 0.5,0.5 ) + lerpResult261.rg);
			float simplePerlin2D222 = snoise( panner229*_NoiseScale );
			simplePerlin2D222 = simplePerlin2D222*0.5 + 0.5;
			float4 lerpResult230 = lerp( color231 , color232 , ( simplePerlin2D222 * _NoiseIntensity ));
			float4 Portal295 = lerpResult230;
			float3 ase_worldPos = i.worldPos;
			float cos329 = cos( _Time.x );
			float sin329 = sin( _Time.x );
			float2 rotator329 = mul( ( (ase_worldPos).xz * 1.0 ) - float2( 0,0 ) , float2x2( cos329 , -sin329 , sin329 , cos329 )) + float2( 0,0 );
			float4 StarryMask321 = saturate( ( tex2D( _TextureSample0, rotator329 ) * float4( i.uv_texcoord, 0.0 , 0.0 ) ) );
			float4 color294 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV272 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode272 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV272, 5.0 ) );
			float fresnelNdotV271 = dot( ase_worldNormal, -i.viewDir );
			float fresnelNode271 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV271, 5.0 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth277 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth277 = saturate( abs( ( screenDepth277 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) ) );
			float FresnelDepth288 = ( ( saturate( fresnelNode272 ) * fresnelNode271 ) + saturate( pow( ( ( 1.0 - distanceDepth277 ) * _DepthScale ) , _DepthFalloff ) ) );
			float4 lerpResult293 = lerp( ( Portal295 + StarryMask321 ) , color294 , FresnelDepth288);
			o.Emission = lerpResult293.rgb;
			o.Alpha = saturate( ( _GeneralOpacity + FresnelDepth288 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 worldNormal : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
8;81;1394;950;2709.15;2947.636;2.30167;True;False
Node;AmplifyShaderEditor.CommentaryNode;308;-1662.535,-1538.005;Inherit;False;1700.949;775.3408;Fresnel & Border depth;16;276;277;282;279;269;270;272;280;283;271;281;273;284;274;285;288;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;345;-1679.845,-698.3834;Inherit;False;1838.957;446.9952;Starry Mask;11;334;335;337;333;336;329;328;320;317;319;321;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-1612.535,-985.1924;Inherit;False;Property;_Depth;Depth;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;307;-1695.786,-2307.672;Inherit;False;2088.772;692.8007;Portal General;14;224;260;264;261;234;229;223;228;222;227;232;231;230;295;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;334;-1629.845,-626.1583;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;224;-1573.747,-2257.672;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;277;-1441.305,-1003.526;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;260;-1645.786,-2113.961;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;ce5d79b5b4ce2a0459d6091c1dc86032;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;264;-1622.815,-1910.796;Inherit;False;Property;_FlowmapDistortion;FlowmapDistortion;4;0;Create;True;0;0;0;False;0;False;0.7528376;0.7528376;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;337;-1360.99,-520.1011;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;335;-1420.173,-633.0823;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;269;-1595.778,-1350.312;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;364;318.1989,-919.4831;Inherit;False;1350.954;512.3494;FloatingOffset;11;355;360;351;358;359;347;352;363;361;346;365;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;279;-1157.157,-1003.46;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;234;-1212.268,-1979.162;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;-1177.99,-612.1011;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-1122.758,-884.4778;Inherit;False;Property;_DepthScale;DepthScale;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;261;-1227.215,-2126.46;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;333;-1192.514,-434.3882;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;270;-1339.81,-1302.65;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-904.0268,-878.6647;Inherit;False;Property;_DepthFalloff;DepthFalloff;6;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;355;368.1989,-772.7106;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;223;-1083.567,-1843.704;Inherit;False;Property;_NoiseScale;NoiseScale;2;0;Create;True;0;0;0;False;0;False;2;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;329;-996.7716,-610.55;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;272;-1078.547,-1488.005;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;229;-989.4,-1993.57;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;360;392.999,-621.7645;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-922.8693,-1008.92;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;328;-741.3586,-418.3558;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;228;-736.2438,-1730.871;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;1;0;Create;True;0;0;0;False;0;False;6.917244;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;273;-847.3802,-1477.826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;281;-751.8945,-1011.401;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;222;-735.6133,-1977.497;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;271;-1083.843,-1288.527;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;320;-773.4638,-648.3834;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;ea4be09c139f6b14f9aabd6d6b548d03;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;575.6987,-750.2638;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;351;479.3877,-864.1828;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;231;-397.6151,-2196.887;Inherit;False;Constant;_Filler;Filler;6;0;Create;True;0;0;0;False;0;False;0.206435,0,0.7075472,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;284;-562.4802,-1012.461;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-427.0689,-505.4929;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;-347.406,-1797.63;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;697.9988,-866.6639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;-656.188,-1423.954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;232;-403.8701,-2014.673;Inherit;False;Constant;_NoiseDots;NoiseDots;6;0;Create;True;0;0;0;False;0;False;0.2044826,0.007843141,0.282353,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;347;835.3896,-868.8928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;319;-259.2807,-507.3515;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;230;-74.90266,-1849.599;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;-313.5854,-1281.55;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;352;969.2864,-869.4831;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;365;987.4838,-690.397;Inherit;False;Constant;_Vector2;Vector 2;9;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;288;-151.7855,-1288.051;Inherit;False;FresnelDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;321;-64.88821,-511.415;Inherit;False;StarryMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;219.8178,-1854.396;Inherit;False;Portal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;363;1006.976,-523.1337;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;762.52,-2265.626;Inherit;False;321;StarryMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;296;763.6768,-2357.479;Inherit;False;295;Portal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;1216.475,-858.2335;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;210;1106.57,-1890.06;Inherit;False;Property;_GeneralOpacity;GeneralOpacity;0;0;Create;True;0;0;0;False;0;False;0.2;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;1127.8,-1783.742;Inherit;False;288;FresnelDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;316;986.317,-2300.097;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;346;1427.153,-863.3318;Inherit;False;LocalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;828.7932,-1933.314;Inherit;False;288;FresnelDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;1384.315,-1885.578;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;294;816.7446,-2137.386;Inherit;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;348;1443.464,-1680.82;Inherit;False;346;LocalVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;287;1528.616,-1888.178;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;293;1151.444,-2125.182;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;268;1755.957,-2168.395;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;DarkSphere;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;277;0;276;0
WireConnection;335;0;334;0
WireConnection;279;0;277;0
WireConnection;336;0;335;0
WireConnection;336;1;337;0
WireConnection;261;0;224;0
WireConnection;261;1;260;0
WireConnection;261;2;264;0
WireConnection;270;0;269;0
WireConnection;329;0;336;0
WireConnection;329;2;333;1
WireConnection;272;4;269;0
WireConnection;229;0;261;0
WireConnection;229;2;234;0
WireConnection;280;0;279;0
WireConnection;280;1;282;0
WireConnection;273;0;272;0
WireConnection;281;0;280;0
WireConnection;281;1;283;0
WireConnection;222;0;229;0
WireConnection;222;1;223;0
WireConnection;271;4;270;0
WireConnection;320;1;329;0
WireConnection;358;0;355;1
WireConnection;358;1;360;0
WireConnection;284;0;281;0
WireConnection;317;0;320;0
WireConnection;317;1;328;0
WireConnection;227;0;222;0
WireConnection;227;1;228;0
WireConnection;359;0;351;0
WireConnection;359;1;358;0
WireConnection;274;0;273;0
WireConnection;274;1;271;0
WireConnection;347;0;359;0
WireConnection;319;0;317;0
WireConnection;230;0;231;0
WireConnection;230;1;232;0
WireConnection;230;2;227;0
WireConnection;285;0;274;0
WireConnection;285;1;284;0
WireConnection;352;0;347;0
WireConnection;288;0;285;0
WireConnection;321;0;319;0
WireConnection;295;0;230;0
WireConnection;361;0;352;0
WireConnection;361;1;365;0
WireConnection;361;2;363;0
WireConnection;316;0;296;0
WireConnection;316;1;322;0
WireConnection;346;0;361;0
WireConnection;286;0;210;0
WireConnection;286;1;289;0
WireConnection;287;0;286;0
WireConnection;293;0;316;0
WireConnection;293;1;294;0
WireConnection;293;2;290;0
WireConnection;268;2;293;0
WireConnection;268;9;287;0
WireConnection;268;11;348;0
ASEEND*/
//CHKSM=DB65815D684FC9A8896277BDCF2E74D2AEAB7224
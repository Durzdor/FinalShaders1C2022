// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissapearingBridge"
{
	Properties
	{
		_PlayerPosition("PlayerPosition", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0
		_FallOff("FallOff", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Height("Height", Float) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float3 _PlayerPosition;
		uniform float _Radius;
		uniform float _FallOff;
		uniform float _Height;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _TextureSample1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 transform66 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 appendResult56 = (float3(transform66.x , 0.0 , transform66.z));
			float temp_output_7_0 = pow( ( distance( _PlayerPosition , appendResult56 ) / _Radius ) , ( _FallOff * 100.0 ) );
			v.vertex.xyz += ( temp_output_7_0 * float3(0,-1,0) * _Height );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 transform66 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 appendResult56 = (float3(transform66.x , 0.0 , transform66.z));
			float temp_output_7_0 = pow( ( distance( _PlayerPosition , appendResult56 ) / _Radius ) , ( _FallOff * 100.0 ) );
			float4 lerpResult17 = lerp( tex2D( _TextureSample0, uv_TextureSample0 ) , tex2D( _TextureSample1, ( (ase_worldPos).xz * 0.05 ) ) , temp_output_7_0);
			o.Albedo = lerpResult17.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
12;81;1394;950;1602.374;104.4732;1;True;False
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;66;-1348.374,199.5268;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;56;-907.1511,196.653;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;1;-947.1219,9.166277;Inherit;False;Property;_PlayerPosition;PlayerPosition;0;0;Create;True;0;0;0;False;0;False;0,0,0;17.7864,-2.5,-15.61398;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;39;-856.9339,-313.6655;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-745.6655,220.7384;Inherit;False;Property;_Radius;Radius;1;0;Create;True;0;0;0;False;0;False;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-745.6729,86.77721;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-896.9484,359.2165;Inherit;False;Property;_FallOff;FallOff;2;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-926.767,463.1695;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-636.6725,-318.4008;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-627.7813,-211.1907;Inherit;False;Constant;_WorldSpaceTiling;WorldSpaceTiling;5;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-712.7672,365.1695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-521.2168,145.519;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-400.8737,-309.3336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;7;-348.6645,143.9455;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-152.055,234.5924;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,-1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;37;-131.5941,-335.8942;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;928e478f6342a0d40a3d38c28a499da7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-131.5675,444.0081;Inherit;False;Property;_Height;Height;4;0;Create;True;0;0;0;False;0;False;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-126.6413,-597.7;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;9c66a01f96be243459860235991a978f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1319.076,-30.2345;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;79.26645,142.2159;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;17;369.2059,-247.4491;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;65;-290.9546,363.787;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;634.328,-169.1151;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;DissapearingBridge;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;0;66;1
WireConnection;56;2;66;3
WireConnection;3;0;1;0
WireConnection;3;1;56;0
WireConnection;40;0;39;0
WireConnection;52;0;8;0
WireConnection;52;1;53;0
WireConnection;5;0;3;0
WireConnection;5;1;6;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;7;0;5;0
WireConnection;7;1;52;0
WireConnection;37;1;41;0
WireConnection;15;0;7;0
WireConnection;15;1;14;0
WireConnection;15;2;16;0
WireConnection;17;0;36;0
WireConnection;17;1;37;0
WireConnection;17;2;7;0
WireConnection;0;0;17;0
WireConnection;0;11;15;0
ASEEND*/
//CHKSM=C459F5ACBF3A2111C33ED226FADEF65C0823FC83
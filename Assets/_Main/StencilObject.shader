// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StencilObject"
{
	Properties
	{
		_MainTexture("MainTexture", 2D) = "white" {}
		_Metallic("Metallic", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		ZTest Equal
		Stencil
		{
			Ref 5
			Comp Equal
			Pass Zero
			Fail Keep
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			o.Albedo = tex2D( _MainTexture, uv_MainTexture ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
8;81;1394;950;937;283;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;4;-675,-74;Inherit;True;Property;_MainTexture;MainTexture;0;0;Create;True;0;0;0;False;0;False;9c66a01f96be243459860235991a978f;9c66a01f96be243459860235991a978f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-405,-73;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-244,150;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-261,252;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;StencilObject;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;5;False;-1;False;0;False;-1;0;False;-1;True;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;5;False;-1;255;False;-1;255;False;-1;5;False;-1;2;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;4;0
WireConnection;0;0;1;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=64A92CA9BD5DD61D54AA260D2817D4C98802F29E
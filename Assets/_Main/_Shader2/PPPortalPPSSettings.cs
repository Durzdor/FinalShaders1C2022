// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PPPortalPPSRenderer ), PostProcessEvent.AfterStack, "PPPortal", true )]
public sealed class PPPortalPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Screen" )]
	public TextureParameter _MainTex = new TextureParameter {  };
	[Tooltip( "Distortion" )]
	public TextureParameter _Distortion = new TextureParameter {  };
	[Tooltip( "DistortionIntensity" )]
	public FloatParameter _DistortionIntensity = new FloatParameter { value = 0.1f };
}

public sealed class PPPortalPPSRenderer : PostProcessEffectRenderer<PPPortalPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PPPortal" ) );
		if(settings._MainTex.value != null) sheet.properties.SetTexture( "_MainTex", settings._MainTex );
		if(settings._Distortion.value != null) sheet.properties.SetTexture( "_Distortion", settings._Distortion );
		sheet.properties.SetFloat( "_DistortionIntensity", settings._DistortionIntensity );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

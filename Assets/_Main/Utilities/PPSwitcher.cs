using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PPSwitcher : MonoBehaviour
{
    public Shader shader;
    [Range(0,1)]
    public float intensity;
    private Material mat;
    private static readonly int Intensity = Shader.PropertyToID("_Intensity");

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }

    private void Start()
    {
        mat = new Material(shader);
    }

    private void Update()
    {
        mat.SetFloat(Intensity, intensity);
    }
}
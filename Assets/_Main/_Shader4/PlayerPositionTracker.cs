using UnityEngine;

public class PlayerPositionTracker : MonoBehaviour
{
    public Material mat;
    
    private static readonly int PointPosition = Shader.PropertyToID("_PlayerPosition");
    
    private void Update()
    {
        mat.SetVector(PointPosition, transform.position);
    }
}

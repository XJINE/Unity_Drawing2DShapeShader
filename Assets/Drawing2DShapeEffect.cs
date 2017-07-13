using System.Runtime.InteropServices;
using UnityEngine;

public class Drawing2DShapeEffect : MonoBehaviour
{
    #region Field

    public Shader drawing2DShapeShader;

    Material drawing2DShapeShaderMaterial;

    #endregion Field

   #region Method

    void Start()
    {
        this.drawing2DShapeShaderMaterial = new Material(this.drawing2DShapeShader);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, this.drawing2DShapeShaderMaterial);
    }

    void OnDestroy()
    {
        GameObject.Destroy(this.drawing2DShapeShaderMaterial);
    }

    #endregion Method
}
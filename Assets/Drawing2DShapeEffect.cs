using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

[ExecuteInEditMode]
public class Drawing2DShapeEffect : ImageEffectBase
{
    #region Enum

    public enum ShapeType : int
    {
        Circle = 0,
        Ring   = 1,
        Sqare  = 2
    }

    #endregion Enum

    #region Struct

    [System.Serializable]
    public struct Shape
    {
        public int     type;
        public Vector4 position;
        public Vector4 parameter;
        public Color   color;
    }

    #endregion Struct

    #region Field

    private ComputeBuffer shapeBuffer;
    public  List<Shape>   shapes;

    private new Camera camera;

    #endregion Field

    #region Property

    #endregion Property

    #region Method

    protected override void Start()
    {
        base.Start();
        this.camera = base.GetComponent<Camera>();
    }

    protected override void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (this.shapes.Count != 0)
        {
            this.shapeBuffer = new ComputeBuffer(this.shapes.Count, Marshal.SizeOf(typeof(Shape)));
            this.shapeBuffer.SetData(this.shapes);
        }

        base.material.SetBuffer("_ShapeBuffer", this.shapeBuffer);

        base.OnRenderImage(src, dest);
    }

    protected void OnDestroy()
    {
        if (this.shapeBuffer != null)
        {
            this.shapeBuffer.Dispose();
            this.shapeBuffer = null;
        }
    }

    public void DrawCircle(Vector3 posInWorld, Color color, float radius, int index = -1)
    {
        DrawCircle(this.camera.WorldToScreenPoint(posInWorld), color, radius, index);
    }

    public void DrawCircle(Vector2 posInScreen, Color color, float radius, int index = -1)
    {
        Shape shape = new Shape()
        {
            type      = 0,
            position  = new Vector4(posInScreen.x, posInScreen.y, 0, 0),
            parameter = new Vector4(radius, 0, 0, 0),
            color     = color
        };

        AddShape(shape);
    }

    public void DrawRing(Vector3 posInWorld, Color color, float innerRadius, float outerRadius, int index = -1)
    {
        DrawRing(this.camera.ViewportToWorldPoint(posInWorld), color, innerRadius, outerRadius, index);
    }

    public void DrawRing(Vector2 posInScreen, Color color, float innerRadius, float outerRadius, int index = -1)
    {
        Shape shape = new Shape()
        {
            type      = 1,
            position  = new Vector4(posInScreen.x, posInScreen.y, 0, 0),
            parameter = new Vector4(innerRadius, outerRadius, 0, 0),
            color = color
        };

        AddShape(shape);
    }

    public void DrawSqare(Vector3 posInWorld, Color color, float size, int index = -1)
    {
        DrawSqare(this.camera.ViewportToWorldPoint(posInWorld), color, size, index);
    }

    public void DrawSqare(Vector2 posInScreen, Color color, float size, int index = -1)
    {
        Shape shape = new Shape()
        {
            type      = 2,
            position  = new Vector4(posInScreen.x, posInScreen.y, 0, 0),
            parameter = new Vector4(size, 0, 0, 0),
            color     = color
        };

        AddShape(shape);
    }

    private void AddShape(Shape shape, int index = -1)
    {
        if (index < 0)
        {
            this.shapes.Add(shape);
        }
        else
        {
            this.shapes.Insert(index, shape);
        }
    }

    #endregion Method
}
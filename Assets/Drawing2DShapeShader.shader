Shader "Hidden/Drawing2DShapeEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull   Off
        ZWrite Off
        ZTest  Always

        Pass
        {
            CGPROGRAM
            
            #include "UnityCG.cginc"

            #pragma target 5.0
            #pragma vertex vert_img
            #pragma fragment frag

            struct Shape
            {
                int    type;
                float4 pos;
                float4 param;
                float4 color;
            };

            StructuredBuffer<Shape> _ShapeBuffer;

            sampler2D _MainTex;

            void drawCircle (float2 inputPos, float2 centerPos, float radius, fixed4 color, inout fixed4 dest)
            {
                float l = length(inputPos - centerPos);

                if (l < radius)
                {
                    dest = color;
                }
            }

            void drawRing (float2 inputPos, float2 centerPos, float innerRad, float outerRad, fixed4 color, inout fixed4 dest)
            {
                float l = length(inputPos - centerPos);

                if (innerRad < l && l < outerRad)
                {
                    dest = color;
                }
            }

            void drawSqare (float2 inputPos, float2 centerPos, float size, fixed4 color, inout fixed4 dest)
            {
                float2 q = (inputPos - centerPos) / size;

                if (abs(q.x) < 1.0 && abs(q.y) < 1.0) 
                {
                    dest = color;
                }
            }

            float4 frag (v2f_img input) : SV_Target
            {
                float4 dest   = tex2D(_MainTex, input.uv);;
                float  aspect = _ScreenParams.x / _ScreenParams.y;

                float2 inputPos = float2(input.uv.x * aspect, input.uv.y);
                float2 centerPos;

                Shape shape;
                int shapeLength = (int)_ShapeBuffer.Length;

                for (int i = 0; i < shapeLength; i++)
                {
                    shape  = _ShapeBuffer[i];
                    centerPos = float2(shape.pos.x * aspect, shape.pos.y);

                    switch(shape.type)
                    {
                        case 0:
                            drawCircle(inputPos, centerPos, shape.param.x, shape.color, dest);
                            break;
                        case 1:
                            drawRing  (inputPos, centerPos, shape.param.x, shape.param.y, shape.color, dest);
                            break;
                        default:
                            drawSqare (inputPos, centerPos, shape.param.x, shape.color, dest);
                            break;
                    }
                }

                return dest;
            }

            ENDCG
        }
    }
}
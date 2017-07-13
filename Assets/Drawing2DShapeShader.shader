Shader "Hidden/Drawing2DShapeShader"
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

            #pragma vertex vert_img
            #pragma fragment frag

            sampler2D _MainTex;

            static const fixed4 white = fixed4(1.0, 1.0, 1.0, 1.0);
            static const fixed4 red   = fixed4(1.0, 0.0, 0.0, 1.0);
            static const fixed4 green = fixed4(0.0, 1.0, 0.0, 1.0);
            static const fixed4 blue  = fixed4(0.0, 0.0, 1.0, 1.0);

            void drawCircle (float2 inputPos, float2 centerPos, float radius,
                             fixed4 color, float aspectRatio, inout fixed4 destination)
            {
                inputPos.x  *= aspectRatio;
                centerPos.x *= aspectRatio;

                float l = length(inputPos - centerPos);

                if (l < radius)
                {
                    destination = color;
                }
            }

            void drawRing(float2 inputPos, float2 centerPos, float innerRadius, float outerRadius,
                          fixed4 color, float aspectRatio, inout fixed4 destination)
            {
                inputPos.x  *= aspectRatio;
                centerPos.x *= aspectRatio;

                float l = length(inputPos - centerPos);

                if (innerRadius < l && l < outerRadius)
                {
                    destination = color;
                }
            }

            void drawSqare (float2 inputPos, float2 centerPos, float length,
                            fixed4 color, float aspectRatio, inout fixed4 destination)
            {
                inputPos.x  *= aspectRatio;
                centerPos.x *= aspectRatio;

                float2 q = (inputPos - centerPos) / length;

                if (abs(q.x) < 1.0 && abs(q.y) < 1.0) 
                {
                    destination = color;
                }
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 destination = white;
                float  aspectRatio = _ScreenParams.x / _ScreenParams.y;

                drawCircle(i.uv, float2(0.5, 0.5), 0.3, red, aspectRatio, destination);
                drawSqare(i.uv, float2(0.3, 0.3), 0.1, green, aspectRatio, destination);
                drawRing(i.uv, float2(0.65, 0.3), 0.1, 0.2, blue, aspectRatio, destination);

                return destination;
            }

            ENDCG
        }
    }
}
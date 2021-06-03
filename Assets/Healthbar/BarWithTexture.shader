Shader "Unlit/HealthbarShader 5"
{
    Properties
    {
        _Health("Health", Range(0,1)) = 1.0
        _StartColor("Start Color", Color) = (1, 0, 0, 1)
        _EndColor("End Color", Color) = (0, 1, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Threshold("Threshold", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Health;
            fixed4 _StartColor;
            fixed4 _EndColor;
            sampler2D _MainTex;
            float _Threshold;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = 1 - v.uv; //???
                return o;
            }

            fixed ilerp(fixed a, fixed b, fixed v)
            {
                return (v - a) / (b - a);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //rounded edges
                float2 coords = i.uv;
                coords.x *= 8;
                float myLine = clamp(coords.x, 0.5, 8 - 0.5);
                float sdf = distance(coords, fixed2(myLine, 0.5)) - _Threshold;
                clip(-sdf);
                
                //color
                fixed4 color = tex2D(_MainTex, float2(_Health, i.uv.y));

                //border
                float sdf2 = sdf + 0.15;
                float borderMask = step(0,-sdf2);
                color *= borderMask;

                //background
                float bgMask = i.uv.x < _Health;
                color *= bgMask;

                //pulse
                if (_Health < 0.2)
                { 
                    float t = cos(_Time.y * 5) + 4;
                    t = t / 4;
                    color *= t;
                }
                return color;
            }
            ENDCG
        }
    }
}

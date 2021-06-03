Shader "Unlit/HealthbarShader 2"
{
    Properties
    {
        _Health("Health", Range(0,1)) = 1.0
        _StartColor("Start Color", Color) = (1, 0, 0, 1)
        _EndColor("End Color", Color) = (0, 1, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        
        Pass
        {
            ZWrite off //try and see what happens with several transparent objects 

            //alpha blending
            //source * X + destination * Y
            //src * srcAlpha + dst * (1-srcAlpha) [actually a lerp with srcalpha as t] [src = color output of shader / dst = image background]
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Health;
            fixed4 _StartColor;
            fixed4 _EndColor;

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
                o.uv = v.uv;
                return o;
            }

            fixed ilerp(fixed a, fixed b, fixed v)
            {
                return (v - a) / (b - a);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed t = saturate(ilerp(0.2, 0.8, _Health));
                fixed4 color = lerp(_StartColor, _EndColor, t);

                fixed4 bgColor = fixed4(0, 0, 0, 0);
                float mask = i.uv.x < _Health;
                color = lerp(bgColor, color, mask);

                return color;
            }
            ENDCG
        }
    }
}

Shader "Unlit/HealthbarShader 4"
{
    Properties
    {
        _Health("Health", Range(0,1)) = 1.0
        _StartColor("Start Color", Color) = (1, 0, 0, 1)
        _EndColor("End Color", Color) = (0, 1, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        
        Pass
        {
            ZWrite on //try and see what happens with several transparent objects 

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
            sampler2D _MainTex;

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
                fixed4 color = lerp(_StartColor, _EndColor, _Health);

                fixed4 bgColor = fixed4(0, 0, 0, 0);
                color = lerp(bgColor, color, i.uv.x);

                return color;
            }
            ENDCG
        }
    }
}

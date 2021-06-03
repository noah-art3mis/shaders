Shader "Unlit/Letters"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex ("Texture", 2D) = "blue" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Oscillation ("Oscillation", Range(1,10)) = 5
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

            sampler2D _MainTex;
            sampler2D _SecondTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Oscillation;

            float2 FlowUV(float2 uv, float x, float y) 
            {
                uv.x += x;
                uv.y += y;
                return uv;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = FlowUV(i.uv, _Time.y, _Time.y);
                fixed4 col = tex2D(_MainTex, uv);

                //other texture
                //fixed4 stex = tex2D(_SecondTex, uv);
                //col *= stex;

                //blink
                //float r = cos(_Time.y * _Oscillation) * 0.5 + 0.5;
                //col *= float4(r, 0, 0, 1);

                float4 c = float4(i.uv, 0, 1);
                col *= c;

                return col;
            }
            ENDCG
        }
    }
}

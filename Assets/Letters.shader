Shader "Unlit/Letters"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _Oscillation("Oscillation", Range(1,10)) = 5
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
            float4 _MainTex_ST;
            float4 _Color;
            float _Oscillation;

            float2 FlowUV(float2 uv, float time) 
            {
                return uv + time;
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
                float2 uv = FlowUV(i.uv, _Time.y);
                fixed4 col = tex2D(_MainTex, uv);
                
                //blink
                float r = cos(_Time.y * _Oscillation) * 0.5 + 0.5;
                col *= float4(r, 0, 0, 1);

                return col;
            }
            ENDCG
        }
    }
}

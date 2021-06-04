Shader "Unlit/Letters"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Flow("Flow Map", 2D) = "black" {}
        [Space]
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
            sampler2D _FlowMap;
            float4 _MainTex_ST;
            float4 _Color;
            float _Oscillation;

            float2 FlowUV(float2 uv, float2 flow, float time)
            {
                return uv + flow * time;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(1 - v.uv, _MainTex); //invert uvs
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed2 flowVector = tex2D(_FlowMap, i.uv);
                fixed2 flowedUV = FlowUV(i.uv, flowVector, _Time.y);
                fixed4 col = tex2D(_MainTex, flowedUV);

                //Oscillation
                //float r = cos(_Time.y * _Oscillation) * 0.5 + 0.5;
                //col *= float4(r, 0, 0, 1);

                //UV Color
                //float4 c = float4(i.uv, 0, 1);
                //col *= c;

                return fixed4(flowVector,0,1); //bugged flow map shows as solid color
            }
            ENDCG
        }
    }
}

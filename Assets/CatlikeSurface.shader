Shader "Custom/DistortionFlow" 
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		[Space]
		[NoScaleOffset] _FlowMap("Flow (RG flow, A noise)", 2D) = "black" {}
		_UJump("U jump per phase", Range(-0.25, 0.25)) = 0.25
		_VJump("V jump per phase", Range(-0.25, 0.25)) = 0.25
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		#include "Flow.cginc"

		sampler2D _MainTex;
		sampler2D _FlowMap;
		float _UJump, _VJump;

		struct Input 
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf(Input IN, inout SurfaceOutputStandard o) 
		{
			fixed2 flowVector = 1;//tex2D(_FlowMap, IN.uv_MainTex).rg * 2 - 1; //manual decoding
			fixed noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			fixed time = _Time.y * noise;
			float2 jump = float2(_UJump, _VJump);

			fixed3 uvwA = FlowUVW(IN.uv_MainTex, flowVector, jump, time, false);
			fixed3 uvwB = FlowUVW(IN.uv_MainTex, flowVector, jump, time, true);
			fixed4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
			fixed4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;
			fixed4 c = (texA + texB) * _Color;
			
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
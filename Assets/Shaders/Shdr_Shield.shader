Shader "Custom/Shdr_Shield"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_PointColor ("Point Color (RGB)" , Color) = (1,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ImpactIntensity("Impact Intensity", Float) = 0
		_Transparency("Transparency", Range(0.0, 1.0)) = 0.25
        
    }
    SubShader
	{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			/*ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha*/

			CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
			//#pragma exclude_renderers d3d11 gles
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;

			struct Input
			{
				float2 uv_MainTex;
				float3 worldPos;
			};

			fixed4 _Color;
			fixed4 _PointColor;

			float _Transparency;
			float _ImpactIntensity;
			int _ShieldPointSize;
			fixed4 _ShieldPoints[50];

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				fixed emissive = 0;

				// Converts world pos to obj pos
				float3 objPos = mul(unity_WorldToObject, float4(IN.worldPos, 1)).xyz;

				for (int i = 0; i < _ShieldPointSize; i++) {
					float rippleSize = (_ShieldPoints[i].w * _ImpactIntensity);
					float distanceFromPt = rippleSize - distance(_ShieldPoints[i].xyz, objPos.xyz) / _ImpactIntensity;
					float fadeRipple = max(0, 1 - _ShieldPoints[i].w);

					//First max() Prevents underflow of color
					emissive += max(0 ,frac(1.0 - max(0, distanceFromPt))* fadeRipple);
				}

				o.Albedo = c.rgb;
				o.Emission = emissive * _PointColor;
				o.Metallic = 0;
				o.Smoothness = 0;

				o.Alpha = c.a;
			}
		ENDCG

	}
    FallBack "Diffuse"
}

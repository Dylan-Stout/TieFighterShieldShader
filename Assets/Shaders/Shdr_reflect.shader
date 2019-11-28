Shader "Custom/Shdr_reflect"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_PointColor("Point Color (RGB)" , Color) = (1,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_RefractionAmount ("Refract Amount", Float) = 0.1
		_ImpactIntensity("Impact Intensity", Float) = 0
    }
    SubShader
    {
        Tags {"Queue"="Transparent"  "ForceNoShadowCasting" = "True"}
        LOD 200

		GrabPass{ "_GrabTexture" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _GrabTexture;

        struct Input
        {
            float4 grabUV;
			float4 refract;
			float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
		float _RefractionAmount;

		fixed4 _PointColor;

		float _Transparency;
		float _ImpactIntensity;
		int _ShieldPointSize;
		fixed4 _ShieldPoints[50];

		void vert(inout appdata_full input, out Input o) {
			float4 pos = UnityObjectToClipPos(input.vertex);
			o.grabUV = ComputeGrabScreenPos(pos);

			o.refract = float4(input.normal,0) * _RefractionAmount;
			o.worldPos = pos;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.grabUV + IN.refract)) * _Color;
			fixed emissive = 0;

			// Converts world pos to obj pos
			float3 objPos = mul(unity_WorldToObject, float4(IN.worldPos, 1)).xyz;

			for (int i = 0; i < _ShieldPointSize; i++) {
				float rippleSize = (_ShieldPoints[i].w * _ImpactIntensity);
				float distanceFromPt = rippleSize - distance(_ShieldPoints[i].xyz, objPos.xyz) / _ImpactIntensity;
				float fadeRipple = max(0, 1 - _ShieldPoints[i].w);

				//First max() Prevents underflow of color
				emissive += max(0, frac(1.0 - max(0, distanceFromPt))* fadeRipple);
			}

            
            o.Albedo = c.rgb;
			o.Emission = emissive * _PointColor;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    //FallBack "Diffuse"
}

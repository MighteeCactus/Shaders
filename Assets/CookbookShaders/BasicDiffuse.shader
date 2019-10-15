Shader "CookbookShaders/BasicDiffuse"
{
    Properties
    {
        _EmissiveColor ("Emissive Color", Color) = (1, 1, 1, 1)
        _AmbientColor("Ambient Color", Color) = (1, 1, 1, 1)
        _SliderValue("Percentage", Range(0, 10)) = 2
        _RampEffect("R Effect", Range(0, 1)) = 1
        _RampTex("Ramp", 2D) = "white"
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BasicDiffuse

        float4 _EmissiveColor;
        float4 _AmbientColor;
        float _SliderValue;
        sampler2D _RampTex;
        float _RampEffect;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float difLight = dot(s.Normal, lightDir);
            float hLambert = difLight * 0.5 + 0.3;
            float rimLight = dot(s.Normal, viewDir);
            float3 dirLightModel = (difLight * atten * 2) * float3(1,1,1); 
            float3 ramp = tex2D(_RampTex, float2(hLambert,rimLight)).rgb;
            
            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * lerp(dirLightModel, ramp, _RampEffect);
            col.a = s.Alpha;
            return col;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = pow((_EmissiveColor + _AmbientColor), _SliderValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "CookbookShaders/SpriteAnim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _TextWidth ("Sheet Width", float) = 0.0
        _CellAmount ("Cell Amount", float) = 0.0
        _Speed ("Speed", Range(0.01, 32)) = 12
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float _TextWidth; 
        float _CellAmount;
        float _Speed;
        
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float cellUVPercentage = 1/_CellAmount;
            float frameNum = fmod(_Time.y * _Speed, _CellAmount);
            frameNum = ceil(frameNum);
            
            float2 spriteUV = IN.uv_MainTex;
            spriteUV.x = (spriteUV.x + frameNum) * cellUVPercentage;
            
            fixed4 c = tex2D (_MainTex, spriteUV);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

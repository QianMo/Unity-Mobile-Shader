
Shader "QianMo/Mobile/Dissolve/MobileDissolveNormalDiffuse" 
{

  Properties 
  {
    _DissolvePower ("Dissolve Power", Range(0.65, -0.5)) = 0.2
    _DissolveEmissionColor ("Dissolve Emission Color", Color) = (1,1,1)
    _MainTex ("Main Texture", 2D) = "white"{}
    _NormalMap("Normal Map", 2D) = "bump"{}
    _DissolveTex("Dissolve Texture", 2D) = "white"{}
  }

  SubShader 
  {
  
    Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
    LOD 300 

    CGPROGRAM
    #pragma surface surf Lambert alphatest:Zero noforwardadd noambient addshadow
    
    sampler2D _MainTex;
    sampler2D _NormalMap;
    sampler2D _DissolveTex;
    float3 _DissolveEmissionColor;
    fixed _DissolvePower;
    
   struct Input {
    float2 uv_MainTex;
    float2 uv_NormalMap;
    float2 uv_DissolveTex;
   };

 
   void surf (Input IN, inout SurfaceOutput o) 
   {
     half4 tex = tex2D(_MainTex, IN.uv_MainTex);
     half4 texd = tex2D(_DissolveTex, IN.uv_DissolveTex);
     
     o.Albedo = tex.rgb;
     o.Gloss = tex.a;
     o.Alpha = _DissolvePower - texd.r;
     o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
     
     if ((o.Alpha < 0)&&(o.Alpha > -0.05)){
       o.Alpha = 1;
       o.Albedo = _DissolveEmissionColor;
     }
   } 
   ENDCG
  }
}
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

v2f vert (appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = v.uv;
	return o;
}

sampler2D _MainTex;
float4 _MainTex_TexelSize;
sampler2D _SourceTex;
sampler2D _GhostTex;
sampler2D _CameraDepthTexture;
fixed4 _BloomTint;
fixed _Intensity;
fixed _BlendFac;
fixed _Ghosting;
fixed _DistMul;

static float blurKernel[3] = {-1.5, 0, 1.5};
static int kernelSize = 3;

fixed4 frag0 (v2f i) : SV_Target
{	
	fixed4 depth = Linear01Depth(tex2D(_CameraDepthTexture, i.uv).r);

	depth = saturate(depth * _DistMul);
	depth = depth * _BloomTint;

	fixed4 ghost = tex2D(_GhostTex, i.uv);
	return lerp(depth, ghost, _Ghosting);
}		

fixed4 frag1 (v2f i) : SV_Target
{
	fixed4 col = 0;			
	for (int p = 0; p < kernelSize; p++){
		col += tex2D(_MainTex, float2(i.uv.x + blurKernel[p] * _MainTex_TexelSize.x, i.uv.y));
	}
	return col / kernelSize;
}

fixed4 frag2 (v2f i) : SV_Target
{
	fixed4 col = 0;	
	for (int p = 0; p < kernelSize; p++){
		col += tex2D(_MainTex, float2(i.uv.x, i.uv.y + blurKernel[p] * _MainTex_TexelSize.y));
	}
	return col / kernelSize;
}

fixed4 frag3 (v2f i) : SV_Target
{
	fixed4 bloom = tex2D(_MainTex, i.uv);
	fixed4 source = tex2D(_SourceTex,i.uv);

	return lerp(source + bloom * _Intensity, bloom * _Intensity , _BlendFac); // Additive
        // return 1 - (1 - source) * (1 - bloom * _Intensity * _BloomTint); // Screen
}

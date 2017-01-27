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
sampler2D _SourceTex;
sampler2D _GhostTex;
sampler2D _CameraDepthTexture;
fixed4 _BloomTint;
fixed _Intensity;
fixed _BlendFac;
fixed _Ghosting;
fixed _DistMul;

// static float positionKernel1D5[5] = {	-2.5, -1.5, 0, 1.5, 2.5 };
// static float positionKernel1DWeights5[5] = { 0.006007, 0.006377, 0.006506, 0.006377, 0.006007 };

static float positionKernel1D25[25] = {	-12.5, -11.5, -10.5, -8.5, -9.5, -7.5, -6.5, -5.5, -4.5, -3.5, -2.5, -1.5, 0, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 11.5, 12.5 };
static float positionKernel1DWeights25[25] = {
	0.000369, 0.000583,	0.000886, 0.001294,	0.001816,
	0.00245, 0.003174, 0.003952, 0.004729, 0.005437,
	0.006007, 0.006377, 0.006506, 0.006377, 0.006007,
	0.005437, 0.004729, 0.003952, 0.003174, 0.00245,
	0.001816, 0.001294, 0.000886, 0.000583, 0.000369
};

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
	float2 inputUV = i.uv;
	fixed4 colorSample = fixed4(0,0,0,0);
			
	for (int i=0; i<25; i++){
		colorSample += tex2D(_MainTex, float2(inputUV.x + positionKernel1D25[i] * positionKernel1DWeights25[i], inputUV.y));
	}
	return colorSample / 25;
}

fixed4 frag2 (v2f i) : SV_Target
{
	float2 inputUV = i.uv;
	fixed4 colorSample = fixed4(0,0,0,0);
			
	for (int i=0; i<25; i++){
			colorSample += tex2D(_MainTex, float2(inputUV.x, positionKernel1D25[i] * positionKernel1DWeights25[i] + inputUV.y));
	}
	return colorSample / 25;
}

fixed4 frag3 (v2f i) : SV_Target
{
	fixed4 bloom = tex2D(_MainTex, i.uv);
	fixed4 source = tex2D(_SourceTex,i.uv);

	return lerp(source + bloom * _Intensity, bloom * _Intensity , _BlendFac);
	//return source + bloom * _Intensity;
}
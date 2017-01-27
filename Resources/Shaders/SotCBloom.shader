Shader "Hidden/SotCBloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 0: Mask
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag0
			#include "SotCBloom.cginc"
			ENDCG
		}

		// 1: Blur horizontal
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag1
			#include "SotCBloom.cginc"
			ENDCG
		}

		// 2: Blur vertical
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag2
			#include "SotCBloom.cginc"
			ENDCG
		}

		// 3: Combiner
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag3
			#include "SotCBloom.cginc"
			ENDCG
		}
	}
}

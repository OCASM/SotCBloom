using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[AddComponentMenu ("OCASM/Image Effects/SotC Bloom")]
[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class SotCBloom : MonoBehaviour {
	[SerializeField]
	[Range (0,10)]
	float intensity = 1f;
	[SerializeField]
	Color bloomTint = Color.white;
	[SerializeField]
	[Range(1,25)]
	int blurIterations = 1;
	[SerializeField]
	[Range (0,1)]
	float blendFac = 0.5f;
	[SerializeField]
	[Range (0,0.999f)]
	float ghostingAmount = 0.95f;
	[Tooltip ("Just play with this lol.")]
	[SerializeField]
	[Range (0,100f)]
	float distanceMultiplier = 1f;
	[Tooltip ("Higher value means lower resolution buffer and therefore better performance. If not using ghosting it causes flickering.")]
	[SerializeField]
	[Range (1,16)]
	int downSampleFactor = 16;

	[SerializeField]
	Shader _shader;
	Material _material;

	RenderTexture bloomRT;
	RenderTexture bloomRT2;
	RenderTexture ghostRT;


	// Use this for initialization
	void OnEnable () {
		_material = new Material (_shader);
	}

	void OnDisable(){
		DestroyImmediate (_material);
		ghostRT.Release ();
	}
	
	// Update is called once per frame

	void OnRenderImage (RenderTexture src, RenderTexture dst) {
		// Create RTs
		bloomRT = RenderTexture.GetTemporary(src.width / downSampleFactor, src.height / downSampleFactor, 0, RenderTextureFormat.DefaultHDR);
		bloomRT2 = RenderTexture.GetTemporary(bloomRT.width, bloomRT.height, 0, RenderTextureFormat.DefaultHDR);
		if (ghostRT == null) { ghostRT = new RenderTexture (bloomRT.width, bloomRT.height, 0, RenderTextureFormat.DefaultHDR); }

		// Pass data to the shader
		_material.SetTexture ("_GhostTex", ghostRT);
		_material.SetTexture ("_SourceTex", src);
		_material.SetColor ("_BloomTint", bloomTint);
		_material.SetFloat ("_Intensity", intensity);
		_material.SetFloat ("_Ghosting", ghostingAmount);
		_material.SetFloat ("_BlendFac", blendFac);
		_material.SetFloat ("_DistMul", distanceMultiplier);

		// Mask creation and blurring
		Graphics.Blit (src, bloomRT, _material, 0);

		for(int i = 0; i < blurIterations; i++){
			Graphics.Blit (bloomRT, bloomRT2, _material, 1);
			Graphics.Blit (bloomRT2, bloomRT, _material, 2);
		}
		// Copy to ghosting RT
		Graphics.Blit (bloomRT, ghostRT);

		// Combine with source texture
		Graphics.Blit (bloomRT, dst, _material, 3);

		// Cleanup
		RenderTexture.ReleaseTemporary(bloomRT);
		RenderTexture.ReleaseTemporary(bloomRT2);
	}
}

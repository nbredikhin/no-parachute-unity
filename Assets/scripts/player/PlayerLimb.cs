using UnityEngine;
using System.Collections;

public class PlayerLimb : MonoBehaviour {

	public Texture textureOk;
	public Texture textureMissing;
	public Vector2 collisionOffset;
	private MeshRenderer meshRenderer;
	void Start()
	{
		meshRenderer = GetComponent<MeshRenderer>();
		SetState(true);
	}
	public void SetState(bool state)
	{
		if (meshRenderer == null)
		{
			return;
		}
		//meshRenderer.enabled = state;
		meshRenderer.material.mainTexture = state ? textureOk : textureMissing;
	}
}

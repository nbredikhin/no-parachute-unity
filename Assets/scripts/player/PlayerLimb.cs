using UnityEngine;
using System.Collections;

public class PlayerLimb : MonoBehaviour 
{

	public Texture textureOk;
	public Texture textureMissing;
	public Vector2 collisionOffset;
	private MeshRenderer meshRenderer;
	private bool state = false;
	public bool State { get { return state; }}
	
	// Движение оторванной конечности
	public float detachedRotationSpeedMul;
	public Vector3 detachedVelocity;
	void Start()
	{
		meshRenderer = GetComponent<MeshRenderer>();
		SetState(true);
	}
	public void SetState(bool state)
	{
		if (this.state == state || meshRenderer == null)
		{
			return;
		}
		this.state = state;
		meshRenderer.material.mainTexture = state ? textureOk : textureMissing;
	}
}

using UnityEngine;
using System.Collections;

using System.Collections.Generic;

public class GameMain: MonoBehaviour 
{
	public GameObject PipeWallPrefab;
	public GameObject DecorativePlanePrefab;

	public int PipeSize  = 10;
	public int PipeCount = 10;

	public int MaxDecorativeTextures = 50;
	public int DecorativePlanesCount = 30;
	public int GameSpeed = 10;

	private GameObject[] pipeWalls;
	private GameObject[] decorativePlanes;
	private GameObject[] planes;

	public int Level = 1;

	void Start () 
	{
		pipeWalls = new GameObject[PipeCount];
		// Assigning level textures
		Texture bufferTexture = Resources.Load<Texture> ("levels/" + Level.ToString() + "/wall");
		for (int i = 0; i < 4; ++i)
		{
			var childRenderer = PipeWallPrefab.transform.GetChild(i).gameObject.GetComponent<MeshRenderer>();
			Debug.Log(childRenderer);
			childRenderer.sharedMaterial.mainTexture = bufferTexture;
		}
		// Spawning wall boxes
		for (int i = 0; i < PipeCount; ++i)
		{
			var wall = (GameObject)Instantiate(PipeWallPrefab, Vector3.down * PipeSize * i, PipeWallPrefab.transform.rotation);
			pipeWalls[i] = wall;
		}

		decorativePlanes = new GameObject[DecorativePlanesCount];
		// Getting all textures for decorations
		List<Texture> decorativeTextures = new List<Texture> ();
		for (int i = 0; i < MaxDecorativeTextures; ++i)
		{
			bufferTexture = Resources.Load<Texture> ("levels/" + Level.ToString() + "/deco/" + (decorativeTextures.Count + 1));
			if (bufferTexture == null)
				break;
			decorativeTextures.Add(bufferTexture);
		} 
		// Spawning all decorative objects
		float distance = PipeCount * PipeSize / DecorativePlanesCount;
		for (int i = 0; i < DecorativePlanesCount; ++i) 
		{
			int rotationMul = Random.Range(0, 4);
			var decorativePlane = (GameObject)Instantiate(DecorativePlanePrefab, Vector3.down * i * distance, DecorativePlanePrefab.transform.rotation);
			int textureIndex = Random.Range(0, decorativeTextures.Count);
			decorativePlane.GetComponent<MeshRenderer>().material.mainTexture = decorativeTextures[textureIndex];
			decorativePlane.transform.Rotate(0, 0, rotationMul * 90);
			decorativePlanes[i] = decorativePlane;
		}
	}

	void Update () 
	{
		foreach (var currentBox in pipeWalls) 
		{
			currentBox.transform.Translate(Vector3.up * Time.deltaTime * GameSpeed);
			if (currentBox.transform.position.y >= PipeSize)
			{
				currentBox.transform.Translate(Vector3.down * PipeCount * PipeSize);
			}
		}
		foreach (var currentDecoPlane in decorativePlanes) 
		{
			currentDecoPlane.transform.Translate(Vector3.up * Time.deltaTime * GameSpeed, Space.World);
			if (currentDecoPlane.transform.position.y >= 0)
			{
				currentDecoPlane.transform.Translate(Vector3.down * (PipeCount - 1) * PipeSize, Space.World);
				int rotationMul = Random.Range(0, 3);
				currentDecoPlane.transform.Rotate(0, 0, rotationMul * 90);
			}
		}
	}
}

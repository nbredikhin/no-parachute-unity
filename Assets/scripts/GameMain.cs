using UnityEngine;
using System.Collections;

using System.Collections.Generic;

public class GameMain: MonoBehaviour 
{
	public GameObject pipeWallPrefab;
	public GameObject decorativePlanePrefab;

	public int pipeSize  = 10;
	public int pipeCount = 10;

	public int maxDecorativeTextures = 50;
	public int decorativePlanesCount = 30;
	public int fallingSpeed = 10;

	private GameObject[] pipeWalls;
	private GameObject[] decorativePlanes;
	private GameObject[] planes;

	public int level = 1;

	void Start () 
	{
        Application.targetFrameRate = 60;

        // Боковые стены
        // Загрузка текстур
        Texture bufferTexture = Resources.Load<Texture> ("levels/" + level.ToString() + "/wall");
		for (int i = 0; i < 4; ++i)
		{
			var childRenderer = pipeWallPrefab.transform.GetChild(i).gameObject.GetComponent<MeshRenderer>();
			Debug.Log(childRenderer);
			childRenderer.sharedMaterial.mainTexture = bufferTexture;
		}
        // Создание стен
        pipeWalls = new GameObject[pipeCount];
        for (int i = 0; i < pipeCount; ++i)
		{
			var wall = (GameObject)Instantiate(pipeWallPrefab, Vector3.down * pipeSize * i, pipeWallPrefab.transform.rotation);
			pipeWalls[i] = wall;
		}

		// Декоративные стены
        // Загрузка текстур
		List<Texture> decorativeTextures = new List<Texture> ();
		for (int i = 0; i < maxDecorativeTextures; ++i)
		{
			bufferTexture = Resources.Load<Texture> ("levels/" + level.ToString() + "/deco/" + (decorativeTextures.Count + 1));
			if (bufferTexture == null)
				break;
			decorativeTextures.Add(bufferTexture);
		}
        // Создание стен
        decorativePlanes = new GameObject[decorativePlanesCount];
        float distance = pipeCount * pipeSize / decorativePlanesCount;
		for (int i = 0; i < decorativePlanesCount; ++i) 
		{
			var decorativePlane = (GameObject)Instantiate(decorativePlanePrefab, Vector3.down * i * distance, decorativePlanePrefab.transform.rotation);
			int textureIndex = Random.Range(0, decorativeTextures.Count);
			decorativePlane.GetComponent<MeshRenderer>().material.mainTexture = decorativeTextures[textureIndex];
			decorativePlane.transform.Rotate(0, 0, Random.Range(0, 4) * 90);
			decorativePlanes[i] = decorativePlane;
		}
	}

	void Update () 
	{
		foreach (var currentBox in pipeWalls) 
		{
			currentBox.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed);
			if (currentBox.transform.position.y >= pipeSize)
			{
				currentBox.transform.Translate(Vector3.down * pipeCount * pipeSize);
			}
		}
		foreach (var currentDecoPlane in decorativePlanes) 
		{
			currentDecoPlane.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed, Space.World);
			if (currentDecoPlane.transform.position.y >= 0)
			{
				currentDecoPlane.transform.Translate(Vector3.down * (pipeCount - 1) * pipeSize, Space.World);
				int rotationMul = Random.Range(0, 3);
				currentDecoPlane.transform.Rotate(0, 0, rotationMul * 90);
			}
		}
	}
}

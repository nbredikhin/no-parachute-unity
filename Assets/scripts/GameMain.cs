using UnityEngine;
using System.Collections;

using System.Collections.Generic;

public struct PlaneObject
{
		
} 

public class GameMain: MonoBehaviour 
{
	public GameObject pipeWallPrefab;
	public GameObject decorativePlanePrefab;
	public GameObject planePrefab;

	private List<PlaneProperties []> planeProperties;

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
		// Тестовая инициализация
		ChangeLevel(3);
	}

	void Update () 
	{
		if (level <= 0)
			return;
		
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
		foreach (var currentPlane in planes)
		{
			currentPlane.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed, Space.World);
			if (currentPlane.transform.position.y >= 0)
			{
				currentPlane.transform.Translate(Vector3.down * (pipeCount - 0) * pipeSize, Space.World);
			}
		}
	}

	public void ChangeLevel(int newLevel)
	{
		// Номер уровня выступает индикатором для Update
		// Положительный номер уровня говорит о том, что нужно выгрузить игру
		if (level > 0)
		{
			 level = 0;
			 fallingSpeed = 0;
			 // Удаление контейнеров
			 pipeWalls = null;
			 decorativePlanes = null;
			 
		}
		
		level = newLevel;
		
		// TODO: Загрузка JSON уровня
		// Тестовый уровень - 3
		fallingSpeed = 10;
		planeProperties = new List<PlaneProperties []>();
		for (int i = 1; i <= 5; ++i)
		{
			int size = 1;
			if (i == 5)
				size = 2;
				
			PlaneProperties [] props = new PlaneProperties[size];
			for (int j = 1; j <= size; ++j)
			{
				var prop = new PlaneProperties();
				string texturePath = "levels/" + level.ToString() + "/planes/" + i.ToString();
				if (i == 5)
				{
					if (j == 1)
						prop.RotationSpeed = 30;
					else 
						texturePath += "_deco";
				}
				prop.TexturePath = texturePath;
				props[j - 1] = prop;
			} 	
			planeProperties.Add(props);
		}
		
        // Боковые стены
        // Загрузка текстур 
        Texture bufferTexture = Resources.Load<Texture> ("levels/" + level.ToString() + "/wall");
		for (int i = 0; i < 4; ++i)
		{
			var childRenderer = pipeWallPrefab.transform.GetChild(i).gameObject.GetComponent<MeshRenderer>();
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
		
		// Тестовое создание плоскостей
		planes = new GameObject[10];
		for (int i = 0; i < 0; ++i)
		{
			var obj = (GameObject)Instantiate(planePrefab, Vector3.down * i * 10, planePrefab.transform.rotation);
			obj.GetComponent<PlaneBehaviour>().Setup(planeProperties[i % 5]);
			planes[i] = obj;
		}
	}
}

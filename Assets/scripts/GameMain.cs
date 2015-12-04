using UnityEngine;
using System.Collections;

using System.Collections.Generic;

using Newtonsoft.Json;

public class SharedData
{
	public static int levelNo = 1;
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

	public Level level;

    private bool isPaused;
	private GameObject player;
	public bool IsPaused
    {
        get
        {
            return isPaused;
        }
    }

	void Start () 
	{
		Application.targetFrameRate = 60;
		if (level == null)
			level = new Level();
		// Тестовая инициализация
		ChangeLevel(SharedData.levelNo);
	}

	void Update () 
	{
		if (level.Number <= 0)
			return;
		
		foreach (var currentBox in pipeWalls) 
		{
			currentBox.transform.Translate(Vector3.up * Time.deltaTime * level.FallingSpeed);
			if (currentBox.transform.position.y >= pipeSize)
			{
				currentBox.transform.Translate(Vector3.down * pipeCount * pipeSize);
			}
		}
		foreach (var currentDecoPlane in decorativePlanes) 
		{
			currentDecoPlane.transform.Translate(Vector3.up * Time.deltaTime * level.FallingSpeed, Space.World);
			if (currentDecoPlane.transform.position.y >= 0)
			{
				currentDecoPlane.transform.Translate(Vector3.down * (pipeCount - 1) * pipeSize, Space.World);
				int rotationMul = Random.Range(0, 3);
				currentDecoPlane.transform.Rotate(0, 0, rotationMul * 90);
			}
		}
		foreach (var currentPlane in planes)
		{
			currentPlane.transform.Translate(Vector3.up * Time.deltaTime * level.FallingSpeed, Space.World);
			if (currentPlane.transform.position.y >= 0)
			{
				currentPlane.transform.Translate(Vector3.down * (pipeCount - 0) * pipeSize, Space.World);
			}
			
			var planeZ = currentPlane.transform.position.y;
			var playerZ = player.transform.position.y;
			
			if (Mathf.Abs(planeZ - playerZ) <= level.FallingSpeed * Time.deltaTime)
			{
				Debug.Log(currentPlane.GetComponent<PlaneBehaviour>().HitTestPoint(player.transform.position));
			}
		}

        // Вращение камеры
        Camera.main.transform.Rotate(0f, 0f, level.CameraRotationSpeed * Time.deltaTime);
	}

	public void ChangeLevel(int newLevel)
	{
		// Номер уровня выступает индикатором для Update
		// Положительный номер уровня говорит о том, что нужно выгрузить игру
		if (level.Number > 0)
		{
			 level.Number = 0;
			 level.FallingSpeed = 0;
			 // Удаление контейнеров
			 pipeWalls = null;
			 decorativePlanes = null;
			 
		}
		
#region TEST
		var levelFile = Resources.Load<TextAsset>("levels/" + newLevel.ToString() + "/level");
		string jsonString = levelFile.text;
		level = new Level();
		level.LoadLevel(jsonString);
		
		// level = JsonConvert.DeserializeObject<Level>(jsonString);
		
		foreach(var currentPlane in level.Planes)
		{
			foreach(var currentLayer in currentPlane)
			{
				currentLayer.TexturePath = "levels/" + level.Number.ToString() + "/planes/" + currentLayer.TexturePath;
			}
		}
#endregion
		
        // Боковые стены
        // Загрузка текстур 
        Texture bufferTexture = Resources.Load<Texture> ("levels/" + level.Number.ToString() + "/wall");
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
			bufferTexture = Resources.Load<Texture> ("levels/" + level.Number.ToString() + "/deco/" + (decorativeTextures.Count + 1));
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
		for (int i = 0; i < 10; ++i)
		{
			var obj = (GameObject)Instantiate(planePrefab, Vector3.down * i * 10, planePrefab.transform.rotation);
			obj.GetComponent<PlaneBehaviour>().Setup(level.Planes[i % level.Planes.Count]);
			int rotationMul = Random.Range(0, 3);
			obj.transform.Rotate(0, rotationMul * 90, 0);
			planes[i] = obj;
		}
		
		player = GameObject.Find("Player");
	}

    // Пауза
    public void SetGamePaused(bool isPaused)
    {
        Time.timeScale = isPaused ? 0f : 1f;
        this.isPaused = isPaused;
    }
}

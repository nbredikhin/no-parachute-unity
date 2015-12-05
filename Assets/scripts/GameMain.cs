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

    private GameObject player;
    private GameUI gameUI;

    private float fallingSpeed;
    private bool isDead;

	private GameObject[] pipeWalls;
	private GameObject[] decorativePlanes;
	private GameObject[] planes;

	public Level level;

    private bool isPaused;
	public bool IsPaused
    {
        get
        {
            return isPaused;
        }
    }

    public bool IsDead
    {
        get
        {
            return isDead;
        }
    }

    void Start () 
	{
		Application.targetFrameRate = 60;
		if (level == null)
			level = new Level();

        gameUI = GameObject.Find("Canvas").GetComponent<GameUI>();
        // Тестовая инициализация
        ChangeLevel(SharedData.levelNo);
	}

	void Update () 
	{
		if (level.Number <= 0)
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
				int rotationMul = Random.Range(0, 3);
				currentPlane.transform.Rotate(0, 0, rotationMul * 90);
			}
			
			var planeZ = currentPlane.transform.position.y;
			var playerZ = player.transform.position.y;
			
			if (Mathf.Abs(planeZ - playerZ) <= fallingSpeed * Time.deltaTime)
			{
                var collidedLayer = currentPlane.GetComponent<PlaneBehaviour>().HitTestPoint(player.transform.position);
				
                if (collidedLayer != null)
                {
                    OnPlayerHitPlane(collidedLayer);
                }
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
			var decorativePlane = (GameObject)Instantiate(decorativePlanePrefab,  Vector3.down * i * distance, decorativePlanePrefab.transform.rotation);
			int textureIndex = Random.Range(0, decorativeTextures.Count);
			decorativePlane.GetComponent<MeshRenderer>().material.mainTexture = decorativeTextures[textureIndex];
			decorativePlane.transform.Rotate(0, 0, Random.Range(0, 4) * 90);
			decorativePlanes[i] = decorativePlane;
		}
		
		// Тестовое создание плоскостей
		planes = new GameObject[10];
		for (int i = 0; i < 10; ++i)
		{
			var obj = (GameObject)Instantiate(planePrefab, Vector3.down * (i * 10 + pipeSize * pipeCount / 2), planePrefab.transform.rotation);
			obj.GetComponent<PlaneBehaviour>().Setup(level.Planes[i % level.Planes.Count]);
            int rotationMul =  Random.Range(0, 3);
			obj.transform.Rotate(0, rotationMul * 90, 0);
			planes[i] = obj;
		}
		
		player = GameObject.Find("Player");
        fallingSpeed = level.FallingSpeed;

    }

    // Пауза
    public void SetGamePaused(bool isPaused)
    {
        Time.timeScale = isPaused ? 0f : 1f;
        this.isPaused = isPaused;
    }
    
    // При выходе из игры
    void OnDestroy()
    {
        // Восстановление timeScale
        Time.timeScale = 1f;
    }

    void OnPlayerHitPlane(GameObject collidedLayer)
    {
        if (isDead)
        {
            return;
        }
        isDead = true;
        fallingSpeed = 0f;
		// Пока так
		player.transform.Translate(Vector3.up * 0.01f);
		player.transform.SetParent(collidedLayer.transform, true);
        gameUI.ShowScreen(gameUI.deathScreen);
    }

    // Разумереть
    public void Undie()
    {
        if (!isDead)
        {
            return;
        }
        fallingSpeed = level.FallingSpeed;
        isDead = false;
        gameUI.ShowScreen(gameUI.gameScreen);
    }
}

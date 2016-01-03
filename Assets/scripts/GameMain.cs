using UnityEngine;
using System.Collections.Generic;

public class GameMain: MonoBehaviour
{
    // Префабы
    public GameObject pipeWallPrefab;
    public GameObject decorativePlanePrefab;
    public GameObject planePrefab;
    public GameObject powerupPrefab;

    // Общие парметры игры
    public int pipeSize = 10;
    public int pipeCount = 10;
    public int maxDecorativeTextures = 50;
    public int decorativePlanesCount = 30;
    public int planesCount = 11;
    
    private PlayerController player;

    private GameUI gameUI;
    // Локальная скорость падения
    private float fallingSpeed;
    public float FallingSpeed { get {return fallingSpeed; }}
    private float adjustedFallingSpeed;

    private bool isDead;
    private bool isPaused;

    // Контейнеры игровых объектов
    private GameObject[] pipeWalls;
    private GameObject[] decorativePlanes;
    private PlaneBehaviour[] planes;
    private List<PowerUp> powerups;

    public Level level;

    // Таймер для спавна бонусов
    public float SpawnInterval = 10; // Test
    private float spawnTimer = 0;

    public bool IsPaused { get { return isPaused; } }
    public bool IsDead { get { return isDead; } }

    private float speedUpTimer = 0;
    private float prepareTime = 2;
    
    // Продолжительность уровня в секундах
    public float levelDuration = 10f;
    // Время, на протяжении которого, запущен уровень
    private float levelRunningTime = 0f;
    // Завершен ли уровень: isLevelFinished = levelRunningTime >= levelDuration;
    private bool isLevelFinished = false;

    void Start()
    {
        Application.targetFrameRate = 60;
        if (level == null)
            level = new Level();

        gameUI = GameObject.Find("Canvas").GetComponent<GameUI>();
       
        ChangeLevel(SharedData.levelNo);
    }

    void Update()
    {
        if (level.Number <= 0)
            return;

        if (speedUpTimer >= 0)
        {
            speedUpTimer -= Time.deltaTime;
            if (speedUpTimer <= 0)
            {
                player.GodMode = false;
                fallingSpeed = level.FallingSpeed;
                adjustedFallingSpeed = level.FallingSpeed;
            }
            else 
            {
                if (speedUpTimer <= prepareTime)
                {
                    fallingSpeed -= (adjustedFallingSpeed - level.FallingSpeed) / prepareTime * Time.deltaTime;
                }
            }
        } 

        spawnTimer += Time.deltaTime;

        if (false && (spawnTimer >= SpawnInterval && !isDead)) // Debug
        {
            int type = Random.Range(1, 4);

            SpawnPowerUp((PowerUp.PowerUpType)type);
            spawnTimer = 0;
        }

        // Обработка боковых стен
        foreach (var currentBox in pipeWalls)
        {
            currentBox.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed);
            if (currentBox.transform.position.y >= pipeSize)
            {
                currentBox.transform.Translate(Vector3.down * pipeCount * pipeSize);
            }
        }
        // Обработка декоративных плоскостей
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
        // Обработка основных плоскостей
        for (int i = 0; i < planes.Length; ++i)
        {
            var currentPlane = planes [i];

            currentPlane.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed, Space.World);
            if (currentPlane.transform.position.y >= 0)
            {
                currentPlane.transform.Translate(Vector3.down * (pipeCount) * pipeSize, Space.World);
                var newPlane = SpawnRandomPlane(currentPlane.transform.position);
                
                Destroy(currentPlane.gameObject);

                planes[i] = newPlane;
                
            }
			
			var planeZ = currentPlane.transform.position.y;
			var playerZ = player.transform.position.y;
			
			if (!isLevelFinished && Mathf.Abs(planeZ - playerZ) <= fallingSpeed * Time.deltaTime)
			{
                var collidedLayer = player.HitTestPlane(currentPlane);
			    
                if (collidedLayer != null)
                {
                    OnPlayerHitPlane(collidedLayer);
                }
            }
        }
        // Обработка бонусов
        for (int  i = 0; i < powerups.Count; ++i)
        {
            var currentPU = powerups[i];
            currentPU.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed, Space.World);
            currentPU.transform.rotation = Camera.main.transform.rotation;
            
            if (currentPU.transform.position.y >= 0)
            {
                Destroy(currentPU);
                powerups[i] = null;

                powerups.RemoveAt(i--);
                continue;
            }
            var powerUpZ = currentPU.transform.position.y;
            var playerZ = player.transform.position.y;

            if (Mathf.Abs(powerUpZ - playerZ) <= fallingSpeed * Time.deltaTime)
            {
                var diff = new Vector2(player.transform.position.x - currentPU.transform.position.x, player.transform.position.z - currentPU.transform.position.z);
                if (!isLevelFinished && diff.magnitude <= player.transform.localScale.x / 2 + currentPU.transform.localScale.x / 2)
                {
                    currentPU.OnPickUp();

                    player.OnPowerUpTaken(currentPU.Type);
                }
            }
        }
        // Вращение камеры
        // Camera.main.transform.Rotate(0f, 0f, level.CameraRotationSpeed * Time.deltaTime);
        
        if (!isDead && !isPaused)
        {
            levelRunningTime += Time.deltaTime;
                       
            if (levelRunningTime >= levelDuration && !isLevelFinished)
            {
                isLevelFinished = true;
                gameUI.ShowScreen(gameUI.passedScreen);
                JoystickInput.isEnabled = false;
            }
        }
 
    }

    public void ChangeLevel(int newLevel)
    {
        // Номер уровня выступает индикатором для Update
        // Положительный номер уровня говорит о том, что нужно выгрузить игру
        if (level.Number > 0)
        {
            level.Number = 0;
            level.FallingSpeed = 0;
            level.CameraRotationSpeed = 0;
            level.Planes = null;
            level.CameraRotationScript = "UniformRotation";
            // Удаление контейнеров
            pipeWalls = null;
            decorativePlanes = null;
            planes = null;
            powerups = null;
            spawnTimer = 0;
        }
        // Загрузка уровня 
        var levelFile = Resources.Load<TextAsset>("levels/" + newLevel.ToString() + "/level");
        level.LoadLevel(levelFile);
        Camera.main.gameObject.AddComponent(System.Type.GetType(level.CameraRotationScript));
        var movementScript = Camera.main.gameObject.GetComponent<BaseCameraRotationScript>();
        movementScript.Setup(level.CameraRotationSpeed);
        
        powerups = new List<PowerUp>();

        // Боковые стены
        // Загрузка текстур 
        Texture bufferTexture = Resources.Load<Texture>("levels/" + level.Number.ToString() + "/wall");
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
            pipeWalls [i] = wall;
        }

        // Декоративные стены
        // Загрузка текстур
        List<Texture> decorativeTextures = new List<Texture>();
        for (int i = 0; i < maxDecorativeTextures; ++i)
        {
            bufferTexture = Resources.Load<Texture>("levels/" + level.Number.ToString() + "/deco/" + (decorativeTextures.Count + 1));
            if (bufferTexture == null)
                break;
            decorativeTextures.Add(bufferTexture);
        }

        // Создание стен
        decorativePlanes = new GameObject[decorativePlanesCount];
        float distance = (float)pipeCount * pipeSize / decorativePlanesCount + 0.01f;
        for (int i = 0; i < decorativePlanesCount; ++i)
        {
            var decorativePlane = (GameObject)Instantiate(decorativePlanePrefab, Vector3.down * i * distance, decorativePlanePrefab.transform.rotation);
            int textureIndex = Random.Range(0, decorativeTextures.Count);
            decorativePlane.GetComponent<MeshRenderer>().material.mainTexture = decorativeTextures [textureIndex];
            decorativePlane.transform.Rotate(0, 0, Random.Range(0, 4) * 90);
            decorativePlanes [i] = decorativePlane;
        }
        
        // Тестовое создание плоскостей
        planes = new PlaneBehaviour[planesCount];
        for (int i = 0; i < planesCount; ++i)
        {
            planes [i] = SpawnRandomPlane(Vector3.down * pipeSize * pipeCount * ((float)i / planesCount + 0.5f));
        }
        
        player = GameObject.Find("Player").GetComponent<PlayerController>();
        fallingSpeed = level.FallingSpeed;
        levelRunningTime = 0f;
        isLevelFinished = false;
        JoystickInput.isEnabled = true;
    }

    private PlaneBehaviour SpawnRandomPlane(Vector3 position)
    {
        int planeNo = Random.Range(0, level.Planes.Count);
        var planeGameObject = (GameObject)Instantiate(planePrefab, position, planePrefab.transform.rotation);
        var plane = planeGameObject.GetComponent<PlaneBehaviour>();
        plane.Setup(level.Planes [planeNo]);
        
        int rotationMul = Random.Range(0, 3);
        planeGameObject.transform.Rotate(0, rotationMul * 90, 0);

        return plane;
    }

    private void SpawnPowerUp(PowerUp.PowerUpType type)
    {
        var scaleX = powerupPrefab.transform.localScale.x;
        var scaleY = powerupPrefab.transform.localScale.y;
        var randomX = Random.Range(-pipeSize / 2 + scaleX, pipeSize / 2 - scaleX);
        var randomZ = Random.Range(-pipeSize / 2 + scaleY, pipeSize / 2 - scaleY);

        var powerupGameObject = (GameObject)Instantiate(powerupPrefab, (new Vector3(randomX, -pipeCount * pipeSize, randomZ)), powerupPrefab.transform.rotation);
        var powerup = powerupGameObject.GetComponent<PowerUp>();
        powerup.Setup(type);
        
        powerups.Add(powerup);
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
        player.transform.position = new Vector3(player.transform.position.x, collidedLayer.transform.position.y + 0.02f, player.transform.position.z);
        player.transform.SetParent(collidedLayer.transform, true);

        var playerSound = player.GetComponent<AudioSource>();
        playerSound.clip = player.Sounds[0];
        playerSound.Play();
        
        player.Die();

        gameUI.ShowScreen(gameUI.deathScreen);
    }

    public void ChangeFallingSpeed(float newSpeed, float time = 0)
    {
        adjustedFallingSpeed = newSpeed;
        fallingSpeed = adjustedFallingSpeed;

        speedUpTimer = time;
    }

    // Разумереть
    public void Respawn()
    {
        if (!isDead)
        {
            return;
        }
        fallingSpeed = level.FallingSpeed;
        isDead = false;
        gameUI.ShowScreen(gameUI.gameScreen);
        player.Respawn();
    }
}

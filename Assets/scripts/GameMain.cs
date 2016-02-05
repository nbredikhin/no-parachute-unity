using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;

public class GameMain: MonoBehaviour
{
    // Камера
    public float shakeCameraDeath = 1.3f;
    // Префабы
    public GameObject pipeWallPrefab;
    public GameObject decorativePlanePrefab;
    public GameObject planePrefab;
    public GameObject powerupPrefab;

    // Общие парметры игры
    public int pipeSize = 10;
    public int pipeCount = 6;
    public int maxDecorativeTextures = 50;
    public int decorativePlanesCount = 30;
    
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
    
    public int LevelToForceLoad = 0;
    
    public Level level;

    // Таймер для спавна бонусов
    public float SpawnInterval = 10; // Test
    private float spawnTimer = 0;

    public bool IsPaused { get { return isPaused; } }
    public bool IsDead { get { return isDead; } }

    private float speedUpTimer = 0;
    private float prepareTime = 2;
    
    // Время, на протяжении которого, запущен уровень
    private float levelRunningTime = 0f;
    // Время, за которое до конца уровня перестают спавнится плоскости
    public int timeBeforeSpawnEnd = 10;
    // Завершен ли уровень: isLevelFinished = levelRunningTime >= levelDuration;
    private bool isLevelFinished = false;
    
    // Счётчик прогресса
    public ProgressCounter progressCounter;
    // Включено ли обучение
    public bool TutorEnabled = true;
    private int tutorialPart = 0;
    public int MaxTutorialParts = 4;
    private bool prevTouchState = false; 
    public ScoreTextManager scoreTextManager;
    private int endlessModeScore = 0;
    
    void Start()
    {
        GameSettings.LoadSettings();
        TutorEnabled = System.Convert.ToBoolean(PlayerPrefs.GetInt("first_time_running", 1));
        
        
        decorativePlanesCount = (int)((float)decorativePlanesCount * Mathf.Clamp(GameSettings.graphicsQuality / 2f, 0f, 1f));
        
        Application.targetFrameRate = 60;
        if (level == null)
            level = new Level();

        gameUI = GameObject.Find("Canvas").GetComponent<GameUI>();
        
        if (LevelToForceLoad > 0)
            SharedData.levelNo = LevelToForceLoad;
            
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
        
        if (!TutorEnabled)
            spawnTimer += Time.deltaTime;

        if ((spawnTimer >= SpawnInterval && !isDead) && (level.LevelDuration - levelRunningTime > timeBeforeSpawnEnd)) // Debug
        {
            List<int> types = new List<int>();
            
            // "Базовые" бонусы - кольцо и увеличение скорости
            types.Add((int)PowerUp.PowerUpType.Ring);
            types.Add((int)PowerUp.PowerUpType.SpeedUp);
            
            // Если все жизни и есть хоть одна оторванная конеченость или не все жизни - то можем заспавнить дополнительную жизнь
            if ((player.lives == player.maxLivesCount && !player.HasFullHealth) || player.lives < player.maxLivesCount)
                types.Add((int)PowerUp.PowerUpType.ExtraLife);
            if (!player.HasFullHealth)
                types.Add((int)PowerUp.PowerUpType.HealthKit);
                
            int type = Utils.GetRandomNumberFromList(types);
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
        
        if (TutorEnabled)
            return;
        
        // Обработка основных плоскостей
        for (int i = 0; i < planes.Length; ++i)
        {
            var currentPlane = planes[i];
            if (currentPlane == null)
                continue;
                
            currentPlane.transform.Translate(Vector3.up * Time.deltaTime * fallingSpeed, Space.World);
            if (currentPlane.transform.position.y >= 0)
            {
                if (level.LevelDuration - levelRunningTime > timeBeforeSpawnEnd)
                {
                    currentPlane.transform.Translate(Vector3.down * (pipeCount) * pipeSize, Space.World);
                    var newPlane = SpawnRandomPlane(currentPlane.transform.position);
                    
                    planes[i] = newPlane;
                }
                Destroy(currentPlane.gameObject);                
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
                Destroy(currentPU.gameObject, currentPU.DisappearingSpeed + 1);
                powerups[i] = null;

                powerups.RemoveAt(i--);
                continue;
            }
            var powerUpZ = currentPU.transform.position.y;
            var playerZ = player.transform.position.y;

            if (Mathf.Abs(powerUpZ - playerZ) <= fallingSpeed * Time.deltaTime)
            {
                var diff = new Vector2(player.transform.position.x - currentPU.transform.position.x, player.transform.position.z - currentPU.transform.position.z);
                if (!currentPU.IsPickedUp && (!player.GodMode && !isLevelFinished && (diff.magnitude <= player.transform.localScale.x / 2 + currentPU.transform.localScale.x / 2)))
                {
                    currentPU.OnPickUp();
                    
                    player.OnPowerUpTaken(currentPU.Type);
                }
            }
        }
        
        if (!isDead && !isPaused)
        {
            levelRunningTime += Time.deltaTime * (fallingSpeed / level.FallingSpeed);
           
            if (level.IsEndless)
            {
                endlessModeScore = (int)(levelRunningTime * 10f);
                progressCounter.SetValue(endlessModeScore);
            }
            else
                progressCounter.SetValue((int)(level.LevelDuration - levelRunningTime));
                       
            if (!level.IsEndless && levelRunningTime >= level.LevelDuration && !isLevelFinished)
            {
                isLevelFinished = true;
                gameUI.ShowScreen(gameUI.passedScreen);
                JoystickInput.isEnabled = false;
                
                MusicManager.BeginMusicFade(0.5f, 0.25f, false);
                
                // Сохранение прогресса
                var currentLevel = PlayerPrefs.GetInt("CurrentLevel", 1);
                PlayerPrefs.SetInt("CurrentLevel", Mathf.Max(level.Number + 1, currentLevel));
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
            level.LevelDuration = 0;
            level.PlanesCount = 0;
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
        
        if (level.Number != 11)
            progressCounter.SetValue((int)(level.LevelDuration));
        else 
            progressCounter.SetValue(0);
        
        Camera.main.gameObject.AddComponent(System.Type.GetType(level.CameraRotationScript));
        var movementScript = Camera.main.gameObject.GetComponent<BaseCameraRotationScript>();
        movementScript.Setup(level.CameraRotationSpeed);
        
        Camera.main.backgroundColor = level.FogColor;
        RenderSettings.fogColor = level.FogColor;
        
        powerups = new List<PowerUp>();
        // TODO: сделать по-умному
        timeBeforeSpawnEnd = (int)(1.5 * pipeSize * pipeCount / level.FallingSpeed);
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
            decorativePlanes[i] = decorativePlane;
            
            decorativePlane.transform.Translate(Vector3.down * 0.1f, Space.World);
        }
        
        // Тестовое создание плоскостей
        planes = new PlaneBehaviour[level.PlanesCount];
        for (int i = 0; i < level.PlanesCount; ++i)
        {
            planes [i] = SpawnRandomPlane(Vector3.down * (pipeSize * pipeCount) * ((float)i / level.PlanesCount + 1.5f));
        }
        
        player = GameObject.Find("Player").GetComponent<PlayerController>();
        fallingSpeed = level.FallingSpeed;
        levelRunningTime = 0f;
        isLevelFinished = false;
        JoystickInput.isEnabled = true;
        
        // Музыка
        if (!MusicManager.PlayMusic("game_theme", 0.5f, 2))
        {
            MusicManager.BeginMusicFade(0.5f, 1, false);
        }
        
        GameObject.Find("tutor").SetActive(TutorEnabled);
        
        if (!level.IsEndless)
            scoreTextManager.HideBest();
        
        endlessModeScore = 0;    
        player.Setup();
        
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
        if (GameSettings.isVibrationEnabled)
            Handheld.Vibrate();
        
        player.Die();
        Camera.main.SendMessage("ShakeCamera", shakeCameraDeath);

        gameUI.ShowScreen(gameUI.deathScreen);
        MusicManager.BeginMusicFade(0.2f, 0.5f, false);
        
        // Отображение и сохранение счёта в бесконечном уровне
        if (level.IsEndless)
        {
            int score = endlessModeScore;
            int bestScore = PlayerPrefs.GetInt("best_score", 0);
            if (score > bestScore)
            {
                PlayerPrefs.SetInt("best_score", score);
                bestScore = score;
            }
            scoreTextManager.ShowScore(score, bestScore);
        }
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
    
    void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus && !isDead)
        {
            gameUI.PauseButtonClick();
        }
    }
    
    public void ShowNextTutorStep()
    {
        Debug.Log("LOOL");
        var tutor = GameObject.Find("tutor");
        tutor.transform.GetChild(tutorialPart++).gameObject.SetActive(false);
        if (tutorialPart >= MaxTutorialParts)
        {
            TutorEnabled = false;
            GameObject.Find("tutor").SetActive(false);
            // Разкомменть после тестов
            PlayerPrefs.SetInt("first_time_running", 0);
            
            return;   
        }
        tutor.transform.GetChild(tutorialPart).gameObject.SetActive(true);
    }
}

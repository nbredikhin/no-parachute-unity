using UnityEngine;
using System.Collections.Generic;

public class PlayerController : MonoBehaviour
{
    // Камерa
    public float shakeCameraHitLimb = 0.2f;
    public float shakeCameraHitBody = 1f;
	// Общие параметры игрока
    public float movementSpeed = 5f;
    public float maxAngle = 30f;
    public float maxHandsAngle = 10f;
    public float missingHandsSpeedAdd = 0.4f;
    public float maxLegsRotation = 10f;
    public float legsRotationSpeed = 2f;
    public float SpeedUpDuration = 5;
    public float detachedLimbsRotationSpeed = 500f;
    public bool GodMode = false;
	public AudioClip[] Sounds;
    public PlayerAnimation playerAnimation;
    
    private Vector2 velocity;
    private GameMain gameMain;
	
	// Конечности
	public string[] limbsNames = {
		"left_hand", 
		"right_hand", 
		"left_leg", 
		"right_leg"
	};
	public 	Dictionary <string, PlayerLimb> limbs;
	private int missingLimbsCount = 0;
	private List<PlayerLimb> detachedLimbs = new List<PlayerLimb>();
    
    // Мигание при бессмертии
    private float blinkingDelay = 100; // в миллисекундах 
    private float blinkingTimer = 0;
    private bool isVisible = true;

    public float godModeTimeoutMax = 3f;
    private bool godModeDisableAfterTimeout = false;
    private float godModeTimeout;

    // Кровь
    public GameObject limbBlood;
    private ParticleSystem deathBloodParticles;
    private ParticleSystem hitParticles;
    // Жизни
    public int maxLivesCount = 3;
    public int lives;
    public LivesHearts livesHearts;
    
    public int skinID = 2;
    private float maxPosition = 0;

    public bool HasFullHealth
    {
        get { return (missingLimbsCount == 0);}
    }

	void Start () 
    {
        gameMain = Camera.main.GetComponent<GameMain>();
                        
        limbs = new Dictionary <string, PlayerLimb>();
		foreach (var name in limbsNames)
		{
			limbs[name] = transform.Find(name).GetComponent<PlayerLimb>();
		}
		RestoreAllLimbs();

		deathBloodParticles = transform.Find("death_blood").GetComponent<ParticleSystem>();
        hitParticles = transform.Find("hit_particles").GetComponent<ParticleSystem>();
		lives = maxLivesCount;
    }
    
    // Вызывается после загрузки уровня
    public void Setup()
    {
        if (gameMain)
        {
            maxPosition = gameMain.pipeSize / 2f - transform.localScale.x / 2f;
            movementSpeed = Mathf.Max(gameMain.FallingSpeed / 10f * movementSpeed, movementSpeed);
        }
        SetupSkin();
    }
    
    public void SetupSkin()
    {
        playerAnimation.frames[0] = Resources.Load<Texture>("skins/" + skinID.ToString() + "/main1");
        playerAnimation.frames[1] = Resources.Load<Texture>("skins/" + skinID.ToString() + "/main2");
        
        foreach (var name in limbsNames)
        {
            limbs[name].textureOk = Resources.Load<Texture>("skins/" + skinID.ToString() + "/" + name + "_ok");
            limbs[name].textureMissing = Resources.Load<Texture>("skins/" + skinID.ToString() + "/" + name + "_missing");
            limbs[name].UpdateTexture();
        }
        
    }

	void Update ()
    {
        if (gameMain != null && (gameMain.IsPaused || gameMain.IsDead))
        {
            return;
        }

        // Мигание игрока при включенном Godmode
        if (GodMode)
        {
        	if (godModeTimeout > 0 && godModeDisableAfterTimeout)
        	{
        		godModeTimeout -= Time.deltaTime;
        		if (godModeTimeout <= 0)
        		{
        			godModeDisableAfterTimeout = false;
        			GodMode = false;
        		}
        	}
            if (blinkingTimer >= blinkingDelay)
            {
                blinkingTimer = 0;
                ToggleVisibility();
            } 
            else
            {
                blinkingTimer += Time.deltaTime * 1000;
            }
        } 
        else
        {
            if (!isVisible)
                ToggleVisibility();
        }

        // Замедление при потере конечностей
        float missingLimbsMul = 1f - missingLimbsCount / 4f;

        // Отклонение игрока в сторону при потере одной руки
        Vector2 missingHandsVelocityAdd = Vector2.zero;
        if (!limbs["left_hand"].State)
        {
            missingHandsVelocityAdd.x -= 1f;
        }
        if (!limbs["right_hand"].State)
        {
            missingHandsVelocityAdd.x += 1f;
        }   
        missingHandsVelocityAdd.x *= missingHandsSpeedAdd * Mathf.Sin(Time.time * Random.value * 2f) / 2f + missingHandsSpeedAdd / 2f;

        // Скорость
        velocity = Vector2.Lerp(velocity, JoystickInput.input * missingLimbsMul + missingHandsVelocityAdd, 10f * Time.deltaTime);

        // Обновление позиции
        float cameraAngle = Camera.main.transform.eulerAngles.y;
        Vector2 movement = Utils.RotateVector2(velocity * movementSpeed * Time.deltaTime, -cameraAngle);
        transform.Translate(new Vector3(movement.x, 0f, movement.y), Space.World);
        
        // Столкновения с боковыми стенами
        transform.position = new Vector3(
            Mathf.Clamp(transform.position.x, -maxPosition, maxPosition), 
            transform.position.y, 
            Mathf.Clamp(transform.position.z, -maxPosition, maxPosition));
        
        // Конечности
        float missingLegsRotationHandsAdd = 0f;
        float missingLegsRotationBodyAdd = 0f;
        // Оторванные ноги
        if (!limbs["left_leg"].State || !limbs["right_leg"].State)
        {
            missingLegsRotationHandsAdd = Mathf.Sin(Time.time * 16f) * 8f;
            missingLegsRotationBodyAdd = Mathf.Sin(Time.time * 3f) * 3f * missingLimbsCount;
        }
        
        float limbsAngleAdd = Mathf.Sin(Time.time * legsRotationSpeed) * maxLegsRotation;
        // Поворот рук
        float handsAngle = -JoystickInput.input.x * maxHandsAngle;
        limbs["left_hand"].transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle + missingLegsRotationHandsAdd + limbsAngleAdd);
        limbs["right_hand"].transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle - missingLegsRotationHandsAdd - limbsAngleAdd);
        
        // Поворот ног  
        limbs["left_leg"].transform.localRotation = Quaternion.Euler(0f, 0f, limbsAngleAdd);
        limbs["right_leg"].transform.localRotation = Quaternion.Euler(0f, 0f, -limbsAngleAdd);
           
        // Вращение туловища
        var bodyAngle = -maxAngle * velocity.x - cameraAngle + missingLegsRotationBodyAdd;
        transform.rotation = Quaternion.Euler(90f, 0f, bodyAngle);
        
        // Движение оторванных конечностей
        for (int i = 0; i < detachedLimbs.Count; i++)
        {
            var limb = detachedLimbs[i];
            limb.transform.Rotate(0f, 0f, detachedLimbsRotationSpeed * Time.deltaTime * limb.detachedRotationSpeedMul);
            limb.transform.Translate(Vector3.up * gameMain.FallingSpeed * Time.deltaTime * 2f + limb.detachedVelocity * Time.deltaTime, Space.World);
            if (limb.transform.position.y > 0)
            {
                Destroy(limb.gameObject);
                detachedLimbs.RemoveAt(i);
                i--;
            }
        }
    }

    public void OnPowerUpTaken(PowerUp.PowerUpType type)
    {
        switch (type)
        {
            case PowerUp.PowerUpType.Ring:
                break; 
            case PowerUp.PowerUpType.HealthKit:
                RestoreAllLimbs();
                break;
            case PowerUp.PowerUpType.SpeedUp:
                gameMain.ChangeFallingSpeed(gameMain.FallingSpeed * 2, 5);
                GodMode = true;
                break;
            case PowerUp.PowerUpType.ExtraLife:
                lives++;
                if (lives > maxLivesCount)
                {
                    RestoreAllLimbs();
                    lives = maxLivesCount;
                }
                livesHearts.SetLivesCount(lives);
                break;
        }
    }

    public GameObject HitTestPlane(PlaneBehaviour plane)
    {
        if (GodMode)
            return null;

        var hitPlane = plane.HitTestPoint(transform.position);
        if (hitPlane != null)
        {
        	if (lives > 1)
        	{
        		lives--;
        		GodMode = true;
        		godModeDisableAfterTimeout = true;
        		godModeTimeout = godModeTimeoutMax;
                // Иначе какой смысл в жизнях?
                RestoreAllLimbs();
        		livesHearts.SetLivesCount(lives);
                
                var audioSource = gameObject.GetComponent<AudioSource>();
                audioSource.clip = Sounds[0];
                audioSource.Play();
                 
                //plane.Visible = false;
                var particlesColor = plane.CreateHole(transform.position);
                hitParticles.startColor = particlesColor * 2f;
                hitParticles.Play();
                
                Camera.main.SendMessage("ShakeCamera", shakeCameraHitBody);
                // Вибрация
                if (GameSettings.isVibrationEnabled)
                    Handheld.Vibrate();
        		return null;
        	}
            return hitPlane;
        }
        foreach (var name in limbsNames)
        {
            if (plane.HitTestPoint(GetLimbPosition(name)) && limbs[name].State)
            {
                limbs[name].SetState(false); 
                // Отлетающая конечность
                CreateDetachedLimb(limbs[name]);
                missingLimbsCount++;

                // Кровь
                Instantiate(limbBlood, transform.position + new Vector3(limbs[name].collisionOffset.x, 0f, limbs[name].collisionOffset.y), transform.rotation);

				// Звук при потере конечности
                var audioSource = gameObject.GetComponent<AudioSource>();
                audioSource.clip = Sounds[1];
                audioSource.Play();
                
                if (GameSettings.isVibrationEnabled)
                    Handheld.Vibrate();
                    
                Camera.main.SendMessage("ShakeCamera", shakeCameraHitLimb);
            }
        }
        return null;
    }
    
    public void CreateDetachedLimb(PlayerLimb limb)
    {
        var limbClone = (PlayerLimb)Instantiate(limb, limb.transform.position, limb.transform.rotation);
        limbClone.detachedRotationSpeedMul = (Random.Range(80f, 150f) - 100f) / 4f;
        limbClone.detachedVelocity = new Vector3(limbClone.collisionOffset.x, 0f, limbClone.collisionOffset.y) * Random.Range(4f, 7f);
        detachedLimbs.Add(limbClone);
    }
    
    // Восстановить все части тела
	public void RestoreAllLimbs()
	{
		foreach (var name in limbsNames)
		{
			limbs[name].SetState(true);
		}
        missingLimbsCount = 0;
	}
	
	public Vector3 GetLimbPosition(string name)
	{
        var limbOffset = limbs[name].collisionOffset;   
		return transform.TransformPoint(limbOffset.x, limbOffset.y, 0f);
	}

    private void ToggleVisibility()
    {
        isVisible = !isVisible;
        var childrenRenderers = gameObject.transform.GetComponentsInChildren<MeshRenderer>();
        foreach (var renderer in childrenRenderers)
        {
            renderer.enabled = isVisible;
        }
    }

    public void Die()
    {
    	deathBloodParticles.Play();
        hitParticles.Stop();
        
        if (!isVisible)
        {
            ToggleVisibility();
        }
    }

    public void Respawn()
    {
    	deathBloodParticles.Stop();
        hitParticles.Stop();
    	lives = maxLivesCount;
    }
}

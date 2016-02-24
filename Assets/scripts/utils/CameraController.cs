using UnityEngine;

public class CameraController : MonoBehaviour 
{
    public GameObject player;
    public GameMain gameMain;
    public float shakePower = 1f;
    public float shakeTime = 1f;
    private float shakePowerMul = 1f;
    private float shakeDelay = 0;
    private float cameraMaxPosition = 0f;
    void Start()
    {
        if (!player)
        {
            player = GameObject.Find("Player");
        }
        //gameMain = GameObject.Find("GameMain").GetComponent<GameMain>();
        cameraMaxPosition = gameMain.pipeSize / 2f - transform.localScale.x / 2f;
    }
    
    public void ShakeCamera(float mul = 1f)
    {
        shakePowerMul = mul;
        shakeDelay = shakeTime;
    }

	void LateUpdate ()
    {
        // Следование камеры за игроком и тряска
        var currentPosition = transform.position;
        currentPosition.x = player.transform.position.x + (Random.value - 0.5f) * shakePower * (shakeDelay / shakeTime) * shakePowerMul * Time.timeScale;
        currentPosition.z = player.transform.position.z + (Random.value - 0.5f) * shakePower * (shakeDelay / shakeTime) * shakePowerMul * Time.timeScale; 
        transform.position = currentPosition;
        
        // Ограничение позиции камеры 
        transform.position = new Vector3(
            Mathf.Clamp(transform.position.x, -cameraMaxPosition, cameraMaxPosition), 
            transform.position.y, 
            Mathf.Clamp(transform.position.z, -cameraMaxPosition, cameraMaxPosition));
        
        // Тряска камеры
        if (shakeDelay > 0)
        {
            shakeDelay = Mathf.Max(0, shakeDelay - Time.deltaTime);
        }
        
    }
}

using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour
{
    public float movementSpeed = 5f;
    public float maxAngle = 30f;
    public float maxHandsAngle = 10f;

    private Vector2 velocity;

    private GameMain gameMain;
    private PlayerLimbs playerLimbs;
	void Start () 
    {
        gameMain = Camera.main.GetComponent<GameMain>();
        playerLimbs = GetComponent<PlayerLimbs>();
    }

	void Update ()
    {
        if (gameMain.IsPaused || gameMain.IsDead)
        {
            return;
        }

        // Скорость
        velocity = Vector2.Lerp(velocity, JoystickInput.input, 10f * Time.deltaTime);

        // Обновление позиции и вращения
        float cameraAngle = Camera.main.transform.eulerAngles.y;
        Vector2 movement = Utils.RotateVector2(velocity * movementSpeed * Time.deltaTime, -cameraAngle);
        transform.Translate(new Vector3(movement.x, 0f, movement.y), Space.World);
        transform.rotation = Quaternion.Euler(90f, 0f, -maxAngle * velocity.x - cameraAngle);

        // Столкновения с боковыми стенами
        float maxPosition = gameMain.pipeSize / 2f - transform.localScale.x / 2f;
        transform.position = new Vector3(
            Mathf.Clamp(transform.position.x, -maxPosition, maxPosition), 
            transform.position.y, 
            Mathf.Clamp(transform.position.z, -maxPosition, maxPosition));
        
        // Конечности
        // Поворот рук
        float handsAngle = -JoystickInput.input.x * maxHandsAngle;
        playerLimbs.limbs["left_hand"].transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle);
        playerLimbs.limbs["right_hand"].transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle);
    }
    
    public GameObject HitTestPlane(GameObject plane)
    {
        var planeBehaviour = plane.GetComponent<PlaneBehaviour>();
        var hitPlane = planeBehaviour.HitTestPoint(transform.position);
        if (hitPlane != null)
        {
            return hitPlane;
        }
        foreach (var name in playerLimbs.limbsNames)
        {
            if (planeBehaviour.HitTestPoint(playerLimbs.GetLimbPosition(name)))
            {
                playerLimbs.limbs[name].SetState(false);   
            }
        }
        return null;
    }
}

using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour
{
    public float movementSpeed = 5f;
    public float maxAngle = 30f;
    public float maxHandsAngle = 10f;

    private Vector2 velocity;

    [SerializeField] GameObject leftHand;
    [SerializeField] GameObject rightHand;

    private GameMain gameMain;

	void Start () 
    {
        gameMain = Camera.main.GetComponent<GameMain>();
    }

	void Update ()
    {
        // Необходимо для избежания изменения поворота рук во время паузы
        if (gameMain.IsPaused)
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
        if (leftHand && rightHand)
        {
            float handsAngle = -JoystickInput.input.x * maxHandsAngle;
            leftHand.transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle);
            rightHand.transform.localRotation = Quaternion.Euler(0f, 0f, handsAngle);
        }
    }
}

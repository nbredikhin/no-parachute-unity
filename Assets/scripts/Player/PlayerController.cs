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

	void Start () 
    {
	
	}

	void Update ()
    {
        // Скорость
        velocity = Vector2.Lerp(velocity, JoystickInput.input, 10 * Time.deltaTime);

        // Обновление позиции и вращения
        Vector2 movement = velocity * movementSpeed * Time.deltaTime;
        transform.Translate(new Vector3(movement.x, 0f, movement.y), Space.World);
        transform.rotation = Quaternion.Euler(90f, 0f, -maxAngle * velocity.x);
        
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

using UnityEngine;

public class FollowingPlayerRotation : BaseCameraRotationScript 
{
    private float cameraSpeed;
    void Start()
    {
        cameraSpeed = 0;
    }
    void Update()
    {
        cameraSpeed -= JoystickInput.input.x * Time.deltaTime * RotationSpeed;
        cameraSpeed *= (1f - 1f * Time.deltaTime);
        transform.Rotate(0f, 0f, cameraSpeed * Time.deltaTime);
    }
    
    public override void Setup(float RotationSpeed, params Object [] AdditionalArguments)
    {
        base.Setup(RotationSpeed, AdditionalArguments);
    } 
}
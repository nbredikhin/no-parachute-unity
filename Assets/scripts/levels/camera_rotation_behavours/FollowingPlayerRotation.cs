using UnityEngine;
using System.Collections;

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
        cameraSpeed *= 0.99f;
        transform.Rotate(0f, 0f, cameraSpeed);
    }
    
    public override void Setup(float RotationSpeed, params Object [] AdditionalArguments)
    {
        base.Setup(RotationSpeed, AdditionalArguments);
    } 
}
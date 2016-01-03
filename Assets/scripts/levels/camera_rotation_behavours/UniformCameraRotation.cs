using UnityEngine;

public class UniformCameraRotation : BaseCameraRotationScript 
{
    void Update()
    {
        transform.Rotate(0, 0, RotationSpeed * Time.deltaTime);
    }
    
    public override void Setup(float RotationSpeed, params Object [] AdditionalArguments)
    {
        base.Setup(RotationSpeed, AdditionalArguments);
    } 
}

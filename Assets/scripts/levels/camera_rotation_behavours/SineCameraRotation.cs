using UnityEngine;
using System.Collections;

public class SineCameraRotation : BaseCameraRotationScript 
{
    void Update()
    {
        transform.Rotate(0f, 0f, RotationSpeed * Mathf.Sin(Time.time) * Time.deltaTime);
    }
    
    public override void Setup(float RotationSpeed, params Object [] AdditionalArguments)
    {
        base.Setup(RotationSpeed, AdditionalArguments);
    } 
}
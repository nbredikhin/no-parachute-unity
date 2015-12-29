using UnityEngine;

public class UniformRotation : BaseMovement 
{
	void Update () 
    {
        transform.Rotate(0, 0, RotationSpeed * Time.deltaTime);
    }
    
    public override void Setup(Vector3 MovementSpeed, float Rotation)
    {
        base.Setup(Vector3.zero, Rotation);
    }
}

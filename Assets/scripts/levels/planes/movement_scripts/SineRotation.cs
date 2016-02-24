using UnityEngine;

public class SineRotation : BaseMovement
{
	void Update () 
    {
        transform.rotation = Quaternion.Euler(90f, Mathf.Sin(Time.time) * Mathf.Rad2Deg * RotationSpeed, 0f) ;
    }
    
    public override void Setup(Vector3 MovementSpeed, float Rotation)
    {
        base.Setup(Vector3.zero, Rotation);
    }
}

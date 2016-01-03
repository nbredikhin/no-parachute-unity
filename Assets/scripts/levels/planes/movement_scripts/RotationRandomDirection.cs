using UnityEngine;
using System.Collections;

public class RotationRandomDirection : BaseMovement {
    private float direction = 1;
	void Update () 
    {
        transform.Rotate(0, 0, RotationSpeed * Time.deltaTime * direction);
    }
    
    public override void Setup(Vector3 MovementSpeed, float Rotation)
    {
        if (Random.value > 0.5)
        {
            direction = -1;
        }
        else
        {
            direction = 1;
        }
        base.Setup(Vector3.zero, Rotation);
	}
}

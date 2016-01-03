using UnityEngine;
using System.Collections;

public class DoorMoving : BaseMovement 
{
	void Update () 
    {
        transform.Translate(MovementSpeed);
    }
    
    public override void Setup(Vector3 MovementSpeed, float Rotation)
    {
        base.Setup(MovementSpeed, Rotation);
    }
}

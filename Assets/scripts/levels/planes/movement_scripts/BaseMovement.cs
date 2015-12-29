using UnityEngine;
using System.Collections;

public class BaseMovement : MonoBehaviour 
{
    public Vector3 MovementSpeed;
    public float RotationSpeed;
    
    public virtual void Setup(Vector3 MovementSpeed, float RotationSpeed) 
    {
        this.MovementSpeed = MovementSpeed;
        this.RotationSpeed = RotationSpeed;
    }
}

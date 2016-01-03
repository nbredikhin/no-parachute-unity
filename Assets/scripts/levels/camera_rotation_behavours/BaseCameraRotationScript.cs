using UnityEngine;

public class BaseCameraRotationScript : MonoBehaviour 
{
    // Возможно, немного переборщил с абстракцией
    public float RotationSpeed;
    
    // В Additional Arguments можно запихать периоды обращения (для синусов) и прочую лабуду, если нужна
    // Если не нужно - просто убрать params и все
    public virtual void Setup(float RotationSpeed, params Object[] AdditionalArguments) 
    {
        this.RotationSpeed = RotationSpeed;
    }
}

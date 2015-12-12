using UnityEngine;

public static class Utils 
{
    public static Vector2 RotateVector2(Vector2 vector, float angle)
    {
        var radians = angle * Mathf.Deg2Rad;
        var ca = Mathf.Cos(radians);
        var sa = Mathf.Sin(radians);
        return new Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y);
    }
}

using UnityEngine;
using System.Collections.Generic;

public static class Utils 
{
    public static Vector2 RotateVector2(Vector2 vector, float angle)
    {
        var radians = angle * Mathf.Deg2Rad;
        var ca = Mathf.Cos(radians);
        var sa = Mathf.Sin(radians);
        return new Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y);
    }
    
    public static int GetRandomNumberFromList(List<int> values)
    {
        int index = Random.Range(0, values.Count);
        return values[index];
    }
}

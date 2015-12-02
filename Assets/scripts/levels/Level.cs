using UnityEngine;
using System.Collections;
using System.Collections.Generic;

// Объект уровня для сериализации
public class Level
{
	public int Number;
	public List< List<PlaneProperties> > Planes;
	public float CameraRotationSpeed;
	public float FallingSpeed;
}

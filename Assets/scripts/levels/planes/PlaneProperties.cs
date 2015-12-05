using UnityEngine;

public class PlaneProperties
 {
	 public string TexturePath
	 {
		get 
		{
			return texturePath;
		}
		set
		{
			MainTexture = Resources.Load<Texture>(value);
			texturePath = value;
		}
	 }
	 public float RotationSpeed;
	 public float SpeedX {get {return MovementSpeed.x;} set {MovementSpeed = new Vector3(value, SpeedY, SpeedZ);}}
	 public float SpeedY {get {return MovementSpeed.y;} set {MovementSpeed = new Vector3(SpeedX, value, SpeedZ);}}
	 public float SpeedZ {get {return MovementSpeed.z;} set {MovementSpeed = new Vector3(SpeedX, SpeedY, value);}}
	 public Vector3 MovementSpeed;
	 
	 public Texture MainTexture { get; private set; }
	 
	 private string texturePath;
	 
	 public bool ShouldSerializeMainTexture()
	 {
		 return false;
	 }
	 public bool ShouldSerializeMovementSpeed()
	 {
		 return false;
	 }
}
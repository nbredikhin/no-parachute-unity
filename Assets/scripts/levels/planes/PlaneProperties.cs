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
     public Vector3 MovementSpeed;
	 public Vector3 SpawnMinimum, SpawnMaximum;
     
     public string MovementScriptName;
     
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
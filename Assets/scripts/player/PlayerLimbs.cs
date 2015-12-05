using UnityEngine;
using System.Collections.Generic;

public class PlayerLimbs : MonoBehaviour {

	public Dictionary<string, PlayerLimb> limbs;
	public string[] limbsNames = {"left_hand", "right_hand", "left_leg", "right_leg"};
	void Start () 
	{
		limbs = new Dictionary<string, PlayerLimb>();
		foreach (var name in limbsNames)
		{
			limbs[name] = transform.Find(name).GetComponent<PlayerLimb>();
		}
		RestoreAllLimbs();
	}
	
	// Восстановить все части тела
	public void RestoreAllLimbs()
	{
		foreach (var name in limbsNames)
		{
			limbs[name].SetState(true);
		}
	}
	
	public Vector3 GetLimbPosition(string name)
	{
		return limbs[name].transform.position + new Vector3(limbs[name].collisionOffset.x, 0f, limbs[name].collisionOffset.y);
	}
}

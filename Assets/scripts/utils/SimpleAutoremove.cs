using UnityEngine;
using System.Collections;

public class SimpleAutoremove : MonoBehaviour {
	public float autoremoveDelay = 1f;

	void Start () 
	{
		Destroy(gameObject, autoremoveDelay);
	}
}

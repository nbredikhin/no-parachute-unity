using UnityEngine;

public class GetCoinsButton : MonoBehaviour {
    public float speed = 2f;
    public float angle = 10f;
	void Start () {
	
	}
    
	void Update () {
	   transform.rotation = Quaternion.Euler(0f, 0f, Mathf.Sin(Time.time * speed) * angle);
	}
}

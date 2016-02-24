using UnityEngine;

public class ArrowButton : MonoBehaviour {
    private Vector3 startPosition;
    public float speed = 2f;
	void Start () {
        startPosition = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
	   transform.position = startPosition + new Vector3(Mathf.Sin(Time.time * speed) * 1f, 0f, 0f);
	}
}

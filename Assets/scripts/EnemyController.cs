using UnityEngine;
using System.Collections;

public class EnemyController : MonoBehaviour 
{
    private GameObject player;
    private float speed = 2f;
    
	void Start () 
    {
        player = GameObject.Find("Player");
        speed = Random.Range(2f, 4f);
	}
    
	void Update () 
    {
        var angle = transform.localRotation.z;
        var offset = transform.position - player.transform.position;
        var targetAngle = Mathf.Atan2(offset.z, offset.x) * Mathf.Rad2Deg + 90f;
        angle = targetAngle + Mathf.Sin(Time.time) * 10f;
        transform.localRotation = Quaternion.Euler(90f, 0f, angle);
        
        transform.Translate(Vector3.up * Time.deltaTime * speed); 
	}
}

using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour {
    public GameObject player;
    void Start()
    {
        if (!player)
        {
            player = GameObject.Find("Player");
        }
    }

	void LateUpdate ()
    {
        var currentPosition = transform.position;
        currentPosition.x = player.transform.position.x;
        currentPosition.z = player.transform.position.z;
        transform.position = currentPosition;
    }
}

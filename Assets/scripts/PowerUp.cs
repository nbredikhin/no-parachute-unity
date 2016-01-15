using UnityEngine;
using System.Collections;

public class PowerUp : MonoBehaviour
{
    public enum PowerUpType
    {
        Ring = 0,
        HealthKit,
        ExtraLife,
        SpeedUp,
        Shrink
    }    

    public Texture[] Textures;
    public PowerUpType Type;
    public AudioClip[] Sounds;

    public float DisappearingSpeed = 4;

    private bool isDisappearing;

    void Start()
    {
    
    }
    
    public void Setup(PowerUpType type)
    {
        Type = type;
        gameObject.GetComponent<MeshRenderer>().material.mainTexture = Textures [(int)type];
        int index = (type == PowerUpType.Ring) ? 0 : 1;
        gameObject.GetComponent<AudioSource>().clip = Sounds [index];

        isDisappearing = false;
    }

    public void OnPickUp()
    {
        gameObject.GetComponent<AudioSource>().Play();
        isDisappearing = true;
    }

    void OnDestroy()
    {
        // если музыка еще играет, ждем 
        var audioSource = gameObject.GetComponent<AudioSource>();
        if (audioSource.isPlaying)
        {
            Debug.Log("Waiting for track to over");
            Wait(audioSource.time);
            Debug.Log("Track is over, destroying");
        }
    }

    IEnumerator Wait(float time)
    {
        yield return new WaitForSeconds(time);
    } 

    void Update()
    {
        if (isDisappearing)
        {
            var material = gameObject.GetComponent<MeshRenderer>().material;
            material.SetColor("_Color", material.color - new Color(0, 0, 0, DisappearingSpeed * Time.deltaTime));
            gameObject.transform.localScale += new Vector3(Time.deltaTime, Time.deltaTime, 0) * DisappearingSpeed;

        }
    }
}

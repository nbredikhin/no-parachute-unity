using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour {
    public Button endlessModeButton;
    public Text unlockText;
    
	void Start () {
       bool isEndlessEnabled = PlayerPrefs.GetInt("CurrentLevel", 1) >= 10;
	   endlessModeButton.interactable = isEndlessEnabled;
       unlockText.enabled = !isEndlessEnabled;
	}
    
    void Update() {
        unlockText.color = new Color(1f, 1f, 1f, Mathf.Sin(Time.time * 2f) * 0.5f + 0.5f);
    }
}

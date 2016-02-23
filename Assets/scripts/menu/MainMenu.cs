using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour {
    public Button endlessModeButton;
    public Text unlockText;
    
	void Start () 
    {
       // Загрузить настройки
       GameSettings.LoadSettings();
       
       bool isEndlessEnabled = PlayerPrefs.GetInt("CurrentLevel", 1) >= 10 || Cheats.UNLOCK_ALL_LEVELS;
	   endlessModeButton.interactable = isEndlessEnabled;
       unlockText.enabled = !isEndlessEnabled;
       
       MusicManager.PlayMusic("menu_theme", 0, 0);
	}
    
    void Update() {
        unlockText.color = new Color(1f, 1f, 1f, Mathf.Sin(Time.time * 2f) * 0.5f + 0.5f);
    }
}

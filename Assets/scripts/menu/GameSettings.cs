using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameSettings : MonoBehaviour 
{
    public static bool isSoundEnabled;
    public static bool isVibrationEnabled;
    public static int graphicsQuality;
    public static float inputSensitivity;
    
    public ButtonStates soundButton;
    public ButtonStates vibrationButton;
    public ButtonStates qualityButton;
    public Slider sensitivitySlider;
    
	void Start () 
    {
        soundButton.AddState("enabled", "Sound: enabled");
        soundButton.AddState("disabled", "Sound: disabled");

        vibrationButton.AddState("enabled", "Vibration: enabled");
        vibrationButton.AddState("disabled", "Vibration: disabled");

        qualityButton.AddState("low", "Quality: low");
        qualityButton.AddState("medium", "Quality: medium");
        qualityButton.AddState("high", "Quality: high");

        // Загрузка настроек
        LoadSettings();
        
        // Звук и вибрация
        soundButton.SetState(isSoundEnabled ? "enabled" : "disabled");
        vibrationButton.SetState(isVibrationEnabled ? "enabled" : "disabled");

        // Качество графики
        switch (graphicsQuality)
        {
        case 0:
            qualityButton.SetState("low");
            break;
        case 1:
            qualityButton.SetState("medium");
            break;
        case 2:
            qualityButton.SetState("high");
            break;
        default:
            qualityButton.SetState("high");
            break;
        }
        // Чувствительность
        sensitivitySlider.value = inputSensitivity;
	}
    
    public static void LoadSettings()
    {
        isSoundEnabled = PlayerPrefs.GetInt("settings_sound", 1) == 1;
        isVibrationEnabled = PlayerPrefs.GetInt("settings_vibration", 1) == 1;
        graphicsQuality = PlayerPrefs.GetInt("settings_quality", 2);
        inputSensitivity = PlayerPrefs.GetFloat("settings_sensitivity", 1);
        
        AudioListener.volume = isSoundEnabled ? 1 : 0;
    }
    
    private void SaveSettings()
    {
        var soundState = soundButton.GetCurrentState();
        var vibrationState = vibrationButton.GetCurrentState();
        var qualityState = qualityButton.GetCurrentState();
        
        PlayerPrefs.SetInt("settings_sound", soundState == "enabled" ? 1 : 0);
        PlayerPrefs.SetInt("settings_vibration", vibrationState == "enabled" ? 1 : 0);
        
        int quality = 0;
        switch (qualityState)
        {
            case "low":
                quality = 0;
                break;
            case "medium": 
                quality = 1;
                break;
            case "high":
                quality = 2;
                break;
        }
        PlayerPrefs.SetInt("settings_quality", quality);
        PlayerPrefs.SetFloat("settings_sensitivity", sensitivitySlider.value);
        
        // Статические переменныее
        isSoundEnabled = soundState == "enabled";
        isVibrationEnabled = vibrationState == "enabled";
        graphicsQuality = quality;
        inputSensitivity = sensitivitySlider.value;
        
        AudioListener.volume = isSoundEnabled ? 1 : 0;
    }
    
    public void BackButtonClick()
    {
        SaveSettings();
        SceneManager.LoadScene("MainMenu");
    }
}

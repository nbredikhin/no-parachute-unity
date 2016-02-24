using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameSettings : MonoBehaviour 
{
    public static bool isSoundEnabled;
    public static bool isVibrationEnabled;
    public static int graphicsQuality;
    public static float inputSensitivity;
    public static bool isJoystickStatic;
    
    public ButtonStates soundButton;
    public ButtonStates vibrationButton;
    public ButtonStates qualityButton;
    public ButtonStates joystickButton;
    public Slider sensitivitySlider;
    
	void Start () 
    {
        string enabled = LocalizedStrings.GetString(StringType.StateEnabled),
               disabled = LocalizedStrings.GetString(StringType.StateDisabled);
        
        string sound = LocalizedStrings.GetString(StringType.Sound),
               quality = LocalizedStrings.GetString(StringType.Quality),
               vibration = LocalizedStrings.GetString(StringType.Vibration),
               joystick = LocalizedStrings.GetString(StringType.Joystick);
        
        
        soundButton.AddState("enabled", sound + ": " + enabled);
        soundButton.AddState("disabled", sound + ": " + disabled);

        vibrationButton.AddState("enabled", vibration + ": " + enabled);
        vibrationButton.AddState("disabled", vibration + ": " + disabled);

        qualityButton.AddState("low", quality + ": " + LocalizedStrings.GetString(StringType.StateLow));
        qualityButton.AddState("medium", quality + ": " + LocalizedStrings.GetString(StringType.StateMedium));
        qualityButton.AddState("high", quality + ": " + LocalizedStrings.GetString(StringType.StateHigh));
        
        joystickButton.AddState("free", joystick + ": " + LocalizedStrings.GetString(StringType.JoystickFree));
        joystickButton.AddState("static", joystick + ": " + LocalizedStrings.GetString(StringType.JoystickStatic));

        // Загрузка настроек
        LoadSettings();
        
        // Звук и вибрация
        soundButton.SetState(isSoundEnabled ? "enabled" : "disabled");
        vibrationButton.SetState(isVibrationEnabled ? "enabled" : "disabled");
        joystickButton.SetState(isJoystickStatic ? "static" : "free");

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
        var joystickState = joystickButton.GetCurrentState();
        
        PlayerPrefs.SetInt("settings_sound", soundState == "enabled" ? 1 : 0);
        PlayerPrefs.SetInt("settings_vibration", vibrationState == "enabled" ? 1 : 0);
        PlayerPrefs.SetInt("settings_joystick", joystickState == "static" ? 1 : 0);
        
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
        isJoystickStatic = joystickState == "static";
        
        AudioListener.volume = isSoundEnabled ? 1 : 0;
        MusicManager.IsMuted = !isSoundEnabled;
        
        PlayerPrefs.Save();
    }
    
    public void BackButtonClick()
    {
        SaveSettings();
        SceneManager.LoadScene("MainMenu");
    }
}

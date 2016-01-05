using UnityEngine;

public class MenuButtonsHandlers : MonoBehaviour
{
    public void StartGame()
    {
        Application.LoadLevel("LevelsMenu");
    }

    public void Settings()
    {
        Application.LoadLevel("SettingsMenu");
    }

    public void StartLevel()
    {
        var levelsIcons = GameObject.Find("levels_icons").GetComponent<LevelsIcons>();
        
        SharedData.levelNo = levelsIcons.SeletedLevel;
        
        Application.LoadLevel("Game");
    }
}

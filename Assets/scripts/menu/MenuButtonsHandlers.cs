using UnityEngine;
using System.Collections;

public class MenuButtonsHandlers : MonoBehaviour
{
    public void StartGame()
    {
        Application.LoadLevel("LevelsMenu");
    }

    public void Settings()
    {

    }

    public void StartLevel()
    {
        var levelsIcons = GameObject.Find("levels_icons").GetComponent<LevelsIcons>();
        
        SharedData.levelNo = levelsIcons.SeletedLevel;
        
        Application.LoadLevel("Game");
    }
}

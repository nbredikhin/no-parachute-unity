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
        Application.LoadLevel("Game");
    }
}

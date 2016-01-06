using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuButtonsHandlers : MonoBehaviour
{
    public void StartGame()
    {
        SceneManager.LoadScene("LevelsMenu");
    }

    public void Settings()
    {
        SceneManager.LoadScene("SettingsMenu");
    }
    
    public void MainMenu()
    {
        SceneManager.LoadScene("MainMenu");
    }
    
    public void CreditsMenu()
    {
        SceneManager.LoadScene("CreditsMenu");
    }

    public void StartLevel()
    {
        var levelsIcons = GameObject.Find("levels_icons").GetComponent<LevelsIcons>();
        
        SharedData.levelNo = levelsIcons.SeletedLevel;
        
        SceneManager.LoadScene("Game");
    }
}

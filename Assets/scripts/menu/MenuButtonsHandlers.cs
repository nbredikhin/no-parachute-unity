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
    
    public void Skins()
    {
        SceneManager.LoadScene("SkinsMenu");
    }
    
    public void MainMenu()
    {
        SceneManager.LoadScene("MainMenu");
    }
    
    public void CreditsMenu()
    {
        SceneManager.LoadScene("CreditsMenu");
    }
    
    public void EndlessMode()
    {
        SharedData.levelNo = 11;
        SceneManager.LoadScene("Game");
    }

    public void StartLevel()
    {
        var levelsIcons = GameObject.Find("levels_icons").GetComponent<LevelsIcons>();
        
        SharedData.levelNo = levelsIcons.SeletedLevel;
        
        SceneManager.LoadScene("Game");
    }
}

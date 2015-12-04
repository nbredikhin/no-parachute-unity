using UnityEngine;
using System.Collections;

public class GameUI : MonoBehaviour {
    public GameObject gameScreen;
    public GameObject pauseScreen;

    private GameObject currentScreen;

	void Start () {
        gameScreen.SetActive(false);
        pauseScreen.SetActive(false);

        ShowScreen(gameScreen);
    }

    void ShowScreen(GameObject screen)
    {
        if (currentScreen)
        {
            currentScreen.SetActive(false);
        }
        currentScreen = screen;
        currentScreen.SetActive(true);
    }

    public void PauseButtonClick()
    {
        // Пауза
        ShowScreen(pauseScreen);
        GameObject.Find("Main Camera").GetComponent<GameMain>().SetGamePaused(true);
    }

    public void ContinueButtonClick()
    {
        // Выход из паузы
        GameObject.Find("Main Camera").GetComponent<GameMain>().SetGamePaused(false);
        ShowScreen(gameScreen);
    }

    public void BackToMenuButtonClick()
    {
        Application.LoadLevel("LevelsMenu");
    }
}

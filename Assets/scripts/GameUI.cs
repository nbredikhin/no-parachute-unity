using UnityEngine;
using System.Collections;

public class GameUI : MonoBehaviour {
	public GameObject gameScreen;
	public GameObject pauseScreen;
	public GameObject deathScreen;
	public GameObject passedScreen;

	private GameObject currentScreen;
	private GameMain gameMain;

	void Start () {
		gameMain = GameObject.Find("Main Camera").GetComponent<GameMain>();

		ShowScreen(deathScreen);
		ShowScreen(passedScreen);	

		gameScreen.SetActive(false);
		pauseScreen.SetActive(false);
		deathScreen.SetActive(false);
		passedScreen.SetActive(false);

		ShowScreen(gameScreen);
	}

	public void ShowScreen(GameObject screen)
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
		gameMain.SetGamePaused(true);
	}

	public void ContinueButtonClick()
	{
		// Выход из паузы
		gameMain.SetGamePaused(false);
		ShowScreen(gameScreen);
	}

	public void TryAgainButtonClick()
	{
		RestartButtonClick();
	}

	public void RestartButtonClick()
	{
		Application.LoadLevel(Application.loadedLevel);
	}

	public void BackToMenuButtonClick()
	{
		Time.timeScale = 1;
		Application.LoadLevel("LevelsMenu");
	}
}

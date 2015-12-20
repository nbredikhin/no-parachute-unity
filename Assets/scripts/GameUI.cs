using UnityEngine;

public class GameUI : MonoBehaviour {
	public GameObject gameScreen;
	public GameObject pauseScreen;
	public GameObject deathScreen;
	public GameObject passedScreen;

	private GameObject currentScreen;
	private GameMain gameMain;
	
	private bool isInitalized;
	void Start () {
		gameMain = GameObject.Find("Main Camera").GetComponent<GameMain>();

		gameScreen.SetActive(true);
		pauseScreen.SetActive(true);
		deathScreen.SetActive(true);
		passedScreen.SetActive(true);

		
		isInitalized = false;
	}
	
	void SetupScreens()
	{
		// Скрыть все экраны после первого кадра
		gameScreen.SetActive(false);
		pauseScreen.SetActive(false);
		deathScreen.SetActive(false);
		passedScreen.SetActive(false);
		
		ShowScreen(gameScreen);
	}
	
	void Update()
	{
		if (!isInitalized)
		{
			SetupScreens();
			isInitalized = true;		
		}
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

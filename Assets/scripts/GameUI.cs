using UnityEngine;
using UnityEngine.SceneManagement;

public class GameUI : MonoBehaviour {
    public GameObject darkScreen;
	public GameObject gameScreen;
	public GameObject pauseScreen;
	public GameObject deathScreen;
	public GameObject passedScreen;

	private GameObject currentScreen;
	private GameMain gameMain;
    private float shitfuckDelay = 0.01f;
	
	private bool isInitalized;
	void Start () {
		gameMain = GameObject.Find("Main Camera").GetComponent<GameMain>();
        
        darkScreen.SetActive(true);
		gameScreen.SetActive(true);
		pauseScreen.SetActive(true);
		deathScreen.SetActive(true);
		passedScreen.SetActive(true);	
        
		isInitalized = false;
	}
	
	void SetupScreens()
	{
		// Скрыть все экраны после первого кадра
        darkScreen.SetActive(false);
		gameScreen.SetActive(false);
		pauseScreen.SetActive(false);
		deathScreen.SetActive(false);
		passedScreen.SetActive(false);
		
		ShowScreen(gameScreen);
	}
	
	void Update()
	{
		if (!isInitalized && shitfuckDelay <= 0)
		{
			SetupScreens();
			isInitalized = true;		
		}
        shitfuckDelay = shitfuckDelay - Time.deltaTime;
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
		SceneManager.LoadScene(SceneManager.GetActiveScene().name);
	}

	public void BackToMenuButtonClick()
	{
		Time.timeScale = 1;
		SceneManager.LoadScene("LevelsMenu");
	}
}

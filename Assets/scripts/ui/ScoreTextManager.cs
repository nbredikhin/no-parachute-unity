using UnityEngine;
using UnityEngine.UI;

public class ScoreTextManager : MonoBehaviour {
    public Text currentScoreText;
    public Text bestScoreText;
    
	void Start () {
	
	}
    
    public void HideBest()
    {
        bestScoreText.gameObject.SetActive(false);   
    }
    
    public void ShowScore(int currentScore, int bestScore)
    {
        currentScoreText.text = "SCORE: " + currentScore.ToString();;
        bestScoreText.text = "BEST: " + bestScore.ToString();
    }
}

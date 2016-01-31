using UnityEngine;
using UnityEngine.UI;

public class RingsCounter : MonoBehaviour {
    public Text counterText;
    public Text shadowText;
	void Start () {
	   
	}
    
	void Update () {
	   counterText.text = shadowText.text = CoinsManager.Balance.ToString();
	}
}

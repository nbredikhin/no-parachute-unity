using UnityEngine;
using UnityEngine.UI;

public class RingsCounter : MonoBehaviour {
    public Text counterText;
	void Start () {
	   
	}
    
	void Update () {
	   counterText.text = CoinsManager.Balance.ToString();
	}
}

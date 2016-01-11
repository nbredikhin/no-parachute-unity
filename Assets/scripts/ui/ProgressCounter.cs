using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ProgressCounter : MonoBehaviour {
    public Text text;
    public Text shadow;
	void Start () {
	
	}
    
    public void SetValue(int value)
    {
        text.text = shadow.text = value.ToString();
    }
    
}

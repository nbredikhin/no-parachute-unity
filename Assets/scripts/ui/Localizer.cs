using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class Localizer : MonoBehaviour 
{
    public StringType type;
    
	void Start () 
    {
	   var text = GetComponent<Text>();
       // Если мы повесили компонент на кнопку
       if (text == null)
       {
           text = GetComponentInChildren<Text>();
       }
       text.text = LocalizedStrings.GetString(type);
	}
}

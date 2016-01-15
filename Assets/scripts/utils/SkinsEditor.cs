using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SkinsEditor : MonoBehaviour {
    public PlayerController player;
    public InputField inputField;
    public Dropdown limbsDropdown;
	// Use this for initialization
	void Start () {
	   //player.SetupSkin();   
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    
    public void UpdateSkin()
    {
        player.skinID = int.Parse(inputField.text); 
        player.SetupSkin();   
    }
    
    public void UpdateLimbs(int value)
    {
        int count = limbsDropdown.value;
        int i = 0;
        Debug.Log(count);
        foreach (var name in player.limbsNames)
        {   
            player.limbs[name].SetState(i < count);
            i++;
        }
    }
}

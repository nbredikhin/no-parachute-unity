using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;

public class ButtonStates : MonoBehaviour 
{
    struct State {
        public string name;
        public string text;
    }
    private int currentState;
     
    private List<State> states = new List<State>();
    private Button button;
    private Text text;

	void Start () 
    {
       button = GetComponent<Button>();
       text = GetComponentInChildren<Text>();
       
       button.onClick.AddListener(() => { NextState(); });
       
       currentState = 0;
	}

    private void NextState()
    {
        currentState++;
        if (currentState >= states.Count)
        {
            currentState = 0;
        }
        text.text = states[currentState].text;
    }

    public void AddState(string name, string text)
    {
        var state = new State();
        state.name = name;
        state.text = text;
        states.Add(state);
    }
    
    public void SetState(string name)
    {
        for (int i = 0; i < states.Count; i++)
        {
            if (states[i].name == name)
            {
                currentState = i;
                text.text = states[currentState].text;
                return;
            }
        }
        currentState = 0;
        text.text = states[currentState].text;
    }
    
    public string GetCurrentState()
    {
        return states[currentState].name;
    }
}

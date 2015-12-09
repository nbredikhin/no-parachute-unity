using UnityEngine;
using UnityEngine.UI;

public class LivesHearts : MonoBehaviour 
{
	private int heartsCount = 3;
	void Start () 
	{
		// TODO: Динамически создавать иконки сердец
		SetLivesCount(heartsCount);
	}

	private void SetHeartState(int index, bool state)
	{
		var heartIcon = transform.Find("heart" + index.ToString());
		var imgs = heartIcon.GetComponentsInChildren<Image>();
		if (imgs.Length == 0)
		{
			return;
		}
		if (state)
		{
			imgs[1].enabled = true;
		}
		else
		{
			imgs[1].enabled = false;
		}
	}

	public void SetLivesCount(int count)
	{
		Mathf.Clamp(count, 0, heartsCount);
		for (int i = 0; i < heartsCount; i++)
		{
			SetHeartState(i + 1, i + 1 <= count);
		}
	}
}

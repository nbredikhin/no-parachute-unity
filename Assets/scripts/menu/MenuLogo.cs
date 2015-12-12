using UnityEngine;

public class MenuLogo : MonoBehaviour
{
    public float maxOffset = 10f;
    public float speed = 1f;
    private RectTransform rectTransform;
    private Vector2 startPosition;

	void Start ()
    {
        rectTransform = GetComponent<RectTransform>();
        startPosition = rectTransform.localPosition;
	}

	void Update ()
    {
        rectTransform.localPosition = startPosition + Vector2.up * Mathf.Sin(Time.time * speed) * maxOffset;
	}
}

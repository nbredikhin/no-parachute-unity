using UnityEngine;

public class PassedScreen : MonoBehaviour 
{
	// Текст
	public RectTransform upperText;
	public RectTransform lowerText;
	public float textMovementSpeed = 50f;
	private Vector3 targetTextPosition;
	
	// Кнопка "Continue"
	public GameObject continueButton;
	public float continueButtonDelay = 2f;
	private float continueButtonCurrentDelay = 0f;

	private bool isStarted = false;
	
	void OnEnable()
	{
		if (!isStarted)
		{
			return;
		}
		upperText.localPosition -= Vector3.right * upperText.rect.width * 2f;
		lowerText.localPosition += Vector3.right * lowerText.rect.width * 2f;
		continueButtonCurrentDelay = continueButtonDelay;
		continueButton.SetActive(false);
	}

	void Start()
	{
		targetTextPosition = upperText.localPosition;
		isStarted = true;
	}
	
	void Update () 
	{
		// Движение текста
		upperText.localPosition = Vector3.Lerp(upperText.localPosition, targetTextPosition, textMovementSpeed * Time.deltaTime);
		lowerText.localPosition = Vector3.Lerp(lowerText.localPosition, targetTextPosition, textMovementSpeed * Time.deltaTime);

		// Активация кнопки после задержки
		if (continueButtonCurrentDelay > 0)
		{
			continueButtonCurrentDelay -= Time.deltaTime;
			if (continueButtonCurrentDelay <= 0)
			{
				continueButton.SetActive(true);
			}
		}
	}
}

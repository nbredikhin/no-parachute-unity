using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class MenuBackground : MonoBehaviour
{
    public GameObject rectPrefab;
    public int rectsCount = 100;
    public float brightness = 0.5f;

    private float canvasWidth;
    private float canvasHeight;

    private Image[] rects;

    void Start()
    {
        var rectTransform = transform.parent.GetComponent<RectTransform>();
        canvasWidth = rectTransform.rect.width;
        canvasHeight = rectTransform.rect.height;
        Debug.Log(canvasWidth);

        rects = new Image[rectsCount];
        float rectWidth = canvasWidth / rectsCount;
        for (int i = 0; i < rectsCount; i++)
        {
            rects[i] = CreateRect(i * rectWidth, 0, rectWidth, canvasHeight);
            rects[i].color = new Color(1f, 0f, 0f, (float)i / (float)rectsCount);
        }

        //CreateRect(50, 0, canvasWidth / 2, canvasHeight / 2);
    }

    Image CreateRect(float x, float y, float width, float height)
    {
        var rect = Instantiate(rectPrefab);
        var rectTransform = rect.GetComponent<RectTransform>();

        rectTransform.offsetMin = new Vector2(x, y - height);
        rectTransform.offsetMax = new Vector2(x + width, height);

        rect.transform.SetParent(transform, false);

        return rect.GetComponent<Image>();
    }

    void Update()
    {
        for (int i = 0; i < rectsCount; i++)
        {
            float mul = (float)i / (float)rectsCount * brightness;
            float r = Random.value * mul;
            float g = Random.value * mul;
            float b = Random.value * mul;
            rects[i].color = new Color(r, g, b);
        }
    }
}

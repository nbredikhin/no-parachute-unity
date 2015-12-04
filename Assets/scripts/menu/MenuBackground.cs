using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class MenuBackground : MonoBehaviour
{
    private Image image;
    private Texture2D texture;

    void Start()
    {
        Application.targetFrameRate = 60;
        image = GetComponent<Image>();
        texture = new Texture2D(100, 1);
        texture.filterMode = FilterMode.Point;
        image.sprite = Sprite.Create(texture, new Rect(0, 0, 100, 1), Vector2.zero);
    }

    void Update()
    {
        for (int i = 0; i < 100; i++)
        {
            var mul = (float)i / 100f * 0.2f;
            texture.SetPixel(i, 0, new Color(Random.value * mul, Random.value * mul, Random.value * mul));
        }
        texture.Apply();
    }

}

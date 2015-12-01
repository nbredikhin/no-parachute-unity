using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class LevelsIcons : MonoBehaviour
{
    enum IconState
    {
        Normal,
        Locked,
        Passed
    };

    public int iconsCount = 10;
    public float iconSpace = 0.1f;
    public float selectedIconScale = 1.4f;
    public GameObject iconPrefab;

    public Sprite[] iconsSprites;
    public Sprite passedSprite;
    public Sprite lockedSprite;

    private GameObject[] icons;
    private int selectedIcon;

    // Номер выбранного уровня
    public int SeletedLevel
        {
            get
            {
                return selectedIcon + 1;
            }
        }

    void Start ()
    {
        icons = new GameObject[iconsCount];
        for (int i = 0; i < iconsCount; i++)
        {
            icons[i] = CreateIcon(i);
        }

        SetSelectedIcon(0);
    }

    GameObject CreateIcon(int index, IconState state = IconState.Normal)
    {
        var icon = Instantiate(iconPrefab);
        icon.transform.SetParent(transform, false);
        var rectTransform = icon.GetComponent<RectTransform>();
    
        // Расположение
        var horizontalOffset = rectTransform.rect.width * (iconSpace + 1) * index;
        rectTransform.anchoredPosition += new Vector2(horizontalOffset, 0f);

        // Иконка
        var iconImage = icon.transform.FindChild("icon").GetComponent<Image>();
        iconImage.sprite = iconsSprites[index];

        // Состояние иконки
        var stateImage = icon.transform.FindChild("state").GetComponent<Image>();
        switch (state)
        {
            case IconState.Locked:
                stateImage.sprite = lockedSprite;
                break;
            case IconState.Passed:
                stateImage.sprite = passedSprite;
                break;
            default:
                stateImage.enabled = false;
                break;
        }

        // Кнопка
        var button = icon.GetComponent<Button>();
        button.onClick.AddListener(() => { ButtonClick(index); });

        return icon;
    }

    void ButtonClick(int index)
    {
        SetSelectedIcon(index);
    }

    void SetSelectedIcon(int index)
    {
        icons[selectedIcon].transform.localScale = Vector2.one;
        selectedIcon = index;
        icons[selectedIcon].transform.localScale *= selectedIconScale;

        var rectTransform = GetComponent<RectTransform>();
        var iconRectTransform = icons[selectedIcon].GetComponent<RectTransform>();
        rectTransform.anchoredPosition = -iconRectTransform.anchoredPosition;
    }

    void Update ()
    {
	
	}
}

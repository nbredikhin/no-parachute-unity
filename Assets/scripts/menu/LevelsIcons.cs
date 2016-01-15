using UnityEngine;
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
    public float maxDragDelta = 100f;
    public GameObject iconPrefab;
    // Иконки и состояния
    public Sprite[] iconsSprites;
    public Sprite passedSprite;
    public Sprite lockedSprite;
    // Цвет рамки
    public Color normalFrameColor;
    public Color selectedFrameColor;
    public Color lockedFrameColor;

    private RectTransform rectTransform;
    private GameObject[] icons;
    private int selectedIcon;

    // Анимация
    public float slidingAnimationSpeed = 10f;
    public float sizeAnimationSpeed = 20f;
    private Vector3 targetScale;
    private Vector2 targetPosition;
    private bool isReallyDragging = false;

    // Номер выбранного уровня
    public int SeletedLevel
        {
            get
            {
                return selectedIcon + 1;
            }
        }

    // Drag 
    private Vector2 startDragPosition;
    private bool isDragging;
    private int fingerId;
    
    private int currentUnlockedLevel; 
    private MenuButtonsHandlers menuButtons;
    private Vector3 previousMousePosition;

    void Start ()
    {
        currentUnlockedLevel = PlayerPrefs.GetInt("CurrentLevel", 1) - 1;
        if (Cheats.UNLOCK_ALL_LEVELS)
        {
            currentUnlockedLevel = iconsCount;
        }
        
        rectTransform = GetComponent<RectTransform>();
        icons = new GameObject[iconsCount];
        for (int i = 0; i < iconsCount; i++)
        {
            IconState state = IconState.Normal;
            if (isLevelLocked(i))
                state = IconState.Locked;
            if (isLevelPassed(i))
                state = IconState.Passed;

            icons[i] = CreateIcon(i, state);
        }

        selectedIcon = -1;
        SetSelectedIcon(currentUnlockedLevel);
        
        menuButtons = GameObject.Find("Canvas").GetComponent<MenuButtonsHandlers>();
    }

    bool isLevelLocked(int index)
    {
        return index > currentUnlockedLevel;
    }

    bool isLevelPassed(int index)
    {
        return index < currentUnlockedLevel;
    }

    GameObject CreateIcon(int index, IconState state = IconState.Normal)
    {
        var icon = Instantiate(iconPrefab);
        icon.transform.SetParent(transform, false);
        var rectTransform = icon.GetComponent<RectTransform>();
    
        // Расположение
        var horizontalOffset = rectTransform.rect.width * (iconSpace + 1) * index;
        rectTransform.anchoredPosition += new Vector2(horizontalOffset, 0f);

        // Кнопка
        var button = icon.GetComponent<Button>();
        button.onClick.AddListener(() => { ButtonClick(index); });
        
        // Рамка
        var frameImage = icon.GetComponent<Image>();
        frameImage.color = normalFrameColor;

        // Иконка
        var iconImage = icon.transform.FindChild("icon").GetComponent<Image>();
        iconImage.sprite = iconsSprites[index];

        // Состояние иконки
        var stateImage = icon.transform.FindChild("state").GetComponent<Image>();
        if (Cheats.UNLOCK_ALL_LEVELS)
            state = IconState.Normal;
        switch (state)
        {
            case IconState.Locked:
                stateImage.sprite = lockedSprite;
                button.interactable = false;
                frameImage.color = lockedFrameColor;
                break;
            case IconState.Passed:
                stateImage.sprite = passedSprite;
                break;
            default:
                stateImage.enabled = false;
                break;
        }

        return icon;
    }

    void ButtonClick(int index)
    {   
        if (isReallyDragging)
        {
            return;
        }
        if (index == selectedIcon)
        {
            menuButtons.StartLevel();                         
        }
        else
            SetSelectedIcon(index);
    }

    void SetSelectedIcon(int index)
    {
        index = Mathf.Clamp(index, 0, iconsCount - 1);
        if (isLevelLocked(index) || selectedIcon == index)
        {
            return;
        }

        Image image;
        // Сброс предыдущей выделенной иконки
        if (selectedIcon >= 0)
        {
            icons[selectedIcon].transform.localScale = Vector2.one;
            image = icons[selectedIcon].GetComponent<Image>();
            image.color = normalFrameColor;
        }

        selectedIcon = index;
        // Позиция
        var iconRectTransform = icons[selectedIcon].GetComponent<RectTransform>();
        targetPosition = -iconRectTransform.anchoredPosition;
        // Выделение 
        var button = icons[selectedIcon].GetComponent<Button>();
        button.Select();
        // Цвет рамки
        image = icons[selectedIcon].GetComponent<Image>();
        image.color = selectedFrameColor;
        // Размер
        targetScale = Vector2.one * selectedIconScale;
    }

    void DragBegin(Vector2 position)
    {
        startDragPosition = position;
        isDragging = true;
        isReallyDragging = false;
    }

    void DragMove(Vector2 position)
    {
        var delta = position.x - startDragPosition.x;
        //Debug.Log(delta);
        if (Mathf.Abs(delta) > 10f && !isReallyDragging)
        {
            //Debug.Log("NO CLICK");
            isReallyDragging = true;
        }
        if (delta > maxDragDelta)
        {
            startDragPosition = position;
            SetSelectedIcon(selectedIcon - 1);
        }
        else if (delta < -maxDragDelta)
        {
            startDragPosition = position;
            SetSelectedIcon(selectedIcon + 1);
        }
    }

    void DragEnd(Vector2 position)
    {
        isDragging = false;
        isReallyDragging = false;
    }

    void Update ()
    {
        //  Управление с клавиатуры
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            SetSelectedIcon(selectedIcon + 1);
        }
        else if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            SetSelectedIcon(selectedIcon - 1);
        }
        
        // Управление касанием
        if (Input.touchSupported)
        {
            foreach (var touch in Input.touches)
            {
                if (isDragging && touch.phase == TouchPhase.Moved && touch.fingerId == fingerId)
                {
                    DragMove(touch.position);
                }
                else if (isDragging && touch.phase == TouchPhase.Ended && touch.fingerId == fingerId)
                {
                    DragEnd(touch.position);
                }
                else if (!isDragging && touch.phase == TouchPhase.Moved)
                {
                    fingerId = touch.fingerId;
                    DragBegin(touch.position);
                }
            }
        }

        // Управление мышью
        if (isDragging && Input.GetMouseButton(0))
        {
            DragMove(Input.mousePosition);
        }
        else if (isDragging && Input.GetMouseButtonUp(0))
        {
            DragEnd(Input.mousePosition);
        }
        else if (!isDragging && Input.GetMouseButton(0))
        {
            DragBegin(Input.mousePosition);
        }

        //  Анимация
        // Плавное изменение размера
        var scale = icons[selectedIcon].transform.localScale;
        scale += (targetScale - scale) * sizeAnimationSpeed * Time.deltaTime;
        icons[selectedIcon].transform.localScale = scale;
        // Плавное изменение позиции
        rectTransform.anchoredPosition += (targetPosition - rectTransform.anchoredPosition) * slidingAnimationSpeed * Time.deltaTime;
        
        previousMousePosition = Input.mousePosition;
    }
}

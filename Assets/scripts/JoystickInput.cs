using UnityEngine;
using System.Collections;

public class JoystickInput : MonoBehaviour
{
    public static Vector2 input;
    public bool useTouchInput = false;
    public float maxJoystickDistance = 70f;

    private bool isTouching;
    private int fingerId;
    private Vector2 startTouchPosition;

	void Start ()
    {
        useTouchInput |= Input.touchSupported;
	}

    private void JoystickMove(Touch touch)
    {
        var delta = touch.position - startTouchPosition;
        // TODO: Чувствительность
        delta = Vector2.ClampMagnitude(delta, maxJoystickDistance);
        input = delta / maxJoystickDistance;
    }

    private void JoystickBegin(Touch touch)
    {
        startTouchPosition = touch.position;
        fingerId = touch.fingerId;
        isTouching = true;
    }

    private void JoystickEnd(Touch touch)
    {
        isTouching = false;
        input = Vector2.zero;
    }

	void Update()
    {
	    if (useTouchInput)
        {
            foreach (var touch in Input.touches)
            {
                if (isTouching && touch.phase == TouchPhase.Moved && touch.fingerId == fingerId)
                {
                    JoystickMove(touch);
                }
                else if (isTouching && touch.phase == TouchPhase.Ended && touch.fingerId == fingerId)
                {
                    JoystickEnd(touch);
                }
                else if (touch.phase == TouchPhase.Began)
                {
                    JoystickBegin(touch);
                }
            }
        }
        else
        {
            input.x = Input.GetAxisRaw("Horizontal");
            input.y = Input.GetAxisRaw("Vertical");
        }
	}


}

using UnityEngine;
using System.Collections;

public class PlayerAnimation : MonoBehaviour {
    public MeshRenderer bodyRenderer;
    public Texture[] frames;
    public float maxFrameDelay = 0.07f;

    private float frameDelay = 0f;
    private int currentFrame = 0;

    void NextFrame()
    {
        currentFrame++;
        if (currentFrame >= frames.Length)
        {
            currentFrame = 0;
        }

        bodyRenderer.material.mainTexture = frames[currentFrame];
    }

	void Update ()
    {
        frameDelay -= Time.deltaTime;
        if (frameDelay <= 0)
        {
            frameDelay = maxFrameDelay;
            NextFrame();
        }
    }
}

using UnityEngine;

public class PlayerAnimation : MonoBehaviour {
    public MeshRenderer bodyRenderer;
    public Texture[] frames;
    public float maxFrameDelay = 0.07f;

    private float frameDelay = 0f;
    private int currentFrame = 0;

    private GameMain gameMain;

    void Start()
    {
        gameMain = Camera.main.GetComponent<GameMain>();
    }

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
        if (gameMain.IsDead)
        {
            return;
        }
        frameDelay -= Time.deltaTime;
        if (frameDelay <= 0)
        {
            frameDelay = maxFrameDelay;
            NextFrame();
        }
    }
}

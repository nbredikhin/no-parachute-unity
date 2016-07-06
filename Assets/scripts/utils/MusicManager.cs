using UnityEngine;
using System.Collections.Generic;

public class MusicManager : MonoBehaviour
{
    public AudioClip[] MusicClips;
    public AudioSource CurrentSource;

    private static MusicManager instance;
    private string nowPLaying;
    private List<FadeManager> faders;

    // Класс для фейдеров (менеджеров затухания)
    public class FadeManager
    {
        public float fadeTime;
        public float fadeStep;
        public bool destroyOnFadeEnd;
        public bool delete;
        public float targetVolume;
        public AudioSource fadingSource;

        public FadeManager(float fadeTime, float targetVolume, bool destroyOnFadeEnd, AudioSource fadingSource)
        {
            this.fadeTime = fadeTime;
            this.targetVolume = targetVolume;
            this.destroyOnFadeEnd = destroyOnFadeEnd;
            this.fadingSource = fadingSource;

            if (fadeTime == 0)
            {
                this.fadingSource.volume = targetVolume;
                if (destroyOnFadeEnd)
                    Destroy(this.fadingSource.gameObject);
                return;
            }

            this.delete = false;
            this.fadeStep = (targetVolume - fadingSource.volume) / this.fadeTime;
        }
    }

    public static bool IsMuted
    {
        get
        {
            return Instance.CurrentSource.mute;
        }
        set
        {
            Instance.CurrentSource.mute = value;
        }
    }

    public static MusicManager Instance
    {
        get
        {
            if (instance == null)
            {
                instance = FindObjectOfType<MusicManager>();

                if (instance == null)
                {
                    var singleton = Instantiate<GameObject>(Resources.Load<GameObject>("music/music_manager"));
                    instance = singleton.GetComponent<MusicManager>();
                    instance.InitFaders();
                    instance.nowPLaying = "";
                    singleton.name = "(singleton)" + typeof(MusicManager).ToString();
                    DontDestroyOnLoad(singleton);
                }
            }
            return instance;
        }
    }
    
    // Методы синглтона
    public static void SetMusicVolume(float volume)
    {
        Instance.SetMusicVolumeInternal(volume);
    }

    public static bool PlayMusic(string name, float prevFadeTime, float newFadeTime)
    {
        return Instance.PlayMusicInternal(name, prevFadeTime, newFadeTime);
    }

    public static void BeginMusicFade(float fadeTime, float targetVolume, bool destroyOnFadeEnd)
    {
        Instance.BeginMusicFadeInternal(Instance.CurrentSource, fadeTime, targetVolume, destroyOnFadeEnd);
    }

    // Методы класса
    private bool PlayMusicInternal(string name, float prevFade, float newFade)
    {
        if (nowPLaying == name)
            return false;

        if (CurrentSource != null)
            BeginMusicFadeInternal(CurrentSource, prevFade, 0, true);

        var musicClip = LoadMusic(name);
        if (musicClip == null)
        {
            Debug.LogError("Music file with name " + name + " not found!");
            return false;
        }
        
        var musicSource =
            Instantiate<GameObject>(Resources.Load<GameObject>("music/music_player")).GetComponent<AudioSource>();

        musicSource.mute = !GameSettings.isSoundEnabled;
        DontDestroyOnLoad(musicSource.gameObject);

        musicSource.gameObject.name = name;
        musicSource.Stop();
        musicSource.clip = musicClip;
        musicSource.volume = 0;
        musicSource.Play();
        nowPLaying = name;
        Debug.Log("Playing music:" + name);

        BeginMusicFadeInternal(musicSource, newFade, 1, false);
        CurrentSource = musicSource;
        return true;
    }

    private AudioClip LoadMusic(string name)
    {
        AudioClip result = null;
        foreach (var currentClip in MusicClips)
        {
            if (currentClip.name == name)
            {
                result = currentClip;
                break;
            }
        }
        return result;
    }

    private void SetMusicVolumeInternal(float volume)
    {
        // Если volume не находится в [0; 1]
        if (Mathf.Abs(volume - 0.5f) > 0.5f)
            return;
        RemoveAllFaders(CurrentSource);
        CurrentSource.volume = volume;
    }

    private void BeginMusicFadeInternal(AudioSource music, float fadeTime, float targetVolume, bool destroyOnFadeEnd)
    {
        FadeManager manager = new FadeManager(fadeTime, targetVolume, destroyOnFadeEnd, music);
        // Удаляем все фейдеры для этого звука 
        RemoveAllFaders(music);
        faders.Add(manager);
    }

    private void InitFaders()
    {
        faders = new List<FadeManager>();
    }

    private void RemoveAllFaders(AudioSource music)
    {
        for (int i = 0; i < faders.Count; ++i)
        {
            var currentFader = faders[i];
            if (currentFader.fadingSource.gameObject.name == music.gameObject.name)
                faders[i].delete = true;
        }
    }

    void Update()
    {
        for (int i = 0; i < faders.Count; ++i)
        {
            var currentFader = faders[i];
            if (currentFader.delete)
            {
                faders.Remove(currentFader);
                continue;
            }
            currentFader.fadingSource.volume += currentFader.fadeStep * Time.deltaTime;
            // Немного предосторожностей - если по каким-то причинам затухание слишком долго происходит, 
            // то перемещаем громость в конечное состояние
            currentFader.fadeTime -= Time.deltaTime;
            if (Mathf.Abs(currentFader.fadingSource.volume - currentFader.targetVolume) < Mathf.Abs(currentFader.fadeStep * Time.deltaTime) / 2 || 
                currentFader.fadeTime <= 0)  
            {
                currentFader.fadingSource.volume = currentFader.targetVolume;
                if (currentFader.destroyOnFadeEnd)
                {
                    Destroy(currentFader.fadingSource.gameObject);
                }
                faders.Remove(currentFader);
            }
        }
    }
}

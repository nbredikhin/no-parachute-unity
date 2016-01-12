using UnityEngine;
using System.Collections.Generic;
using System;

public class MusicManager : MonoBehaviour 
{
    private static MusicManager instance;
    public AudioClip [] MusicClips;
    
    private string nowPLaying;
    private List<FadeManager> faders;
    
    public AudioSource CurrentSource;
    
    public struct FadeManager
    {
        public float fadeTime;
        public float fadeStep;
        public bool destroyOnFadeEnd;
        public float targetVolume;
        public AudioSource fadingSource;
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
                    singleton.name = "(singleton)" + typeof(MusicManager).ToString();
                    
                    DontDestroyOnLoad(singleton);
                }
            }
            return instance;
        }
    }

    public static bool PlayMusic(string name, float prevFadeTime, float newFadeTime)
    {
        return Instance.PlayMusicInternal(name, prevFadeTime, newFadeTime);
    }
    
    public bool PlayMusicInternal(string name, float prevFade, float newFade)
    {
        Debug.Log("Playing music:" + name);
        
        if (nowPLaying == name)
            return true;
        
        if (CurrentSource != null)
            BeginMusicFade(CurrentSource, prevFade, 0, true);
        
        var musicClip = LoadMusic(name);
        if (musicClip == null)
        {
            Debug.LogError("Music file with name " + name + " not found!");
            return false;
        }
        
        var musicSource =
            Instantiate<GameObject>(Resources.Load<GameObject>("music/music_player")).GetComponent<AudioSource>();
        
        DontDestroyOnLoad(musicSource.gameObject);
        
        musicSource.gameObject.name = name;
        musicSource.Stop();
        musicSource.clip = musicClip;
        musicSource.volume = 0;
        musicSource.Play();
        nowPLaying = name;
        
        BeginMusicFade(musicSource, newFade, 1, false);
        CurrentSource = musicSource;
        return true;
    }
    
    public AudioClip LoadMusic(string name)
    {
        AudioClip result = null;
        foreach(var currentClip in MusicClips)
        {
            if (currentClip.name == name)
            {
                result = currentClip;
                break;
            }
        }
        return result;
    }
    
    public void BeginMusicFade(AudioSource music, float fadeTime, float targetVolume, bool destroyOnFadeEnd)
    {
        FadeManager manager = new FadeManager();
        if (fadeTime == 0)
            fadeTime = 0.0001f;
        manager.fadeTime = fadeTime;
        manager.fadingSource = music;
        manager.destroyOnFadeEnd = destroyOnFadeEnd;
        manager.targetVolume = targetVolume;
        
        manager.fadeStep = (targetVolume - music.volume) / manager.fadeTime; 
        Debug.Log(manager.fadeStep);
        faders.Add(manager);
    }
    
    private void InitFaders()
    {
        faders = new List<FadeManager>();
    }
    
    void Update()
    {
        for (int i = 0; i < faders.Count; ++i)
        {
            var currentFader = faders[i];
            currentFader.fadingSource.volume += currentFader.fadeStep * Time.deltaTime;
            if (Mathf.Abs(currentFader.fadingSource.volume - currentFader.targetVolume) < Mathf.Abs(currentFader.fadeStep * Time.deltaTime))
            {
                if (currentFader.destroyOnFadeEnd)
                {
                    Destroy(currentFader.fadingSource.gameObject);
                }
                currentFader.fadingSource.volume = currentFader.targetVolume;
                Debug.LogWarning(faders.Remove(currentFader));
            }
        }
    }
}

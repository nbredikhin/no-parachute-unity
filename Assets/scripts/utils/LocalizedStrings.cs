using System.Collections.Generic;
using SimpleJSON;
using UnityEngine;

public static class LocalizedStrings
{
    private const string LOCALE_FILES_PATH = "locale";
    private static Dictionary<uint, string> localeFiles = new Dictionary<uint, string>
    {
        {(uint)SystemLanguage.English, "english"},
        {(uint)SystemLanguage.Russian, "russian"},
    };
    private static Dictionary<string, string> localizedStrings;

    public static bool LoadLanguage(SystemLanguage lang)
    {
        string file = "english";
        if (!localeFiles.TryGetValue((uint)lang, out file))
            file = "english";
        
        var localeFile = Resources.Load<TextAsset>(LOCALE_FILES_PATH + "/" + file);
        if (!localeFile)
        {
            Debug.LogError("Locale file not found!");
            return false;
        }

        var parsedJSON = JSON.Parse(localeFile.text).AsObject;
        localizedStrings = new Dictionary<string, string>();

        foreach (KeyValuePair<string, JSONNode> pair in parsedJSON)
            localizedStrings.Add(pair.Key, pair.Value.Value);

        return true;
    }
    public static string GetString(string title)
    {
        if (localizedStrings == null)
            return "Locale not loaded";
        return localizedStrings[title];
    }
}

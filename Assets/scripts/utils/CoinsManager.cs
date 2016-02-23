using UnityEngine;

public static class CoinsManager
{
    // TODO: придумать что-нибудь для безопасности?
    public static int Balance
    {
        get
        {
            return PlayerPrefs.GetInt("coins_balance", 0);
        }
        set
        {
            if (value < 0)
                return;
            PlayerPrefs.SetInt("coins_balance", value);
            PlayerPrefs.Save();
        }
    }
}
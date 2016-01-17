using UnityEngine;

public enum StringType
{
    StartGame,
    EndlessMode,
    EndlessModeUnlockText,
    Settings,
    Sound,
    Vibration,
    Quality,
    Sensitivity,
    StateEnabled,
    StateDisabled,
    StateLow,
    StateMedium,
    StateHigh,
    Credits,
    CreditsText,
    Back,
    Start,
    Continue,
    RestartLevel,
    BackToMenu,
    TryAgain,
    SelectCharacter,
    Select,
    DeadText,
    PausedText
}

public static class LocalizedStrings
{
    private static SystemLanguage language = Application.systemLanguage;

    private static string[,] localizedStrings =
    {{"Start game", "Начать игру"},
     {"Endless mode", "Бесконечный режим"},
     {"Complete all levels to unlock", "Пройдите все уровни для открытия"},
     {"Settings", "Настройки"},
     {"Sound", "Звуки"},
     {"Vibration", "Вибрация"},
     {"Quality", "Качество"},
     {"Sensitivity:", "Чувствительность:"},
     {"enabled", "вкл."},
     {"disabled", "выкл."},
     {"low", "низкое"},
     {"medium", "среднее"},
     {"high", "высокое"},
     {"Credits", "Об авторах"},
     {"No Parachute!\n\nProgramming, design:\nNikita Bredikhin\n\nProgramming, music:\nEugene Morozov", "No Parachute!\n\nПрограммирование, дизайн:\nНикита Бредихин\n\nПрограммирование, музыка:\nЕвгений Морозов"},
     {"Back", "Назад"},
     {"START", "НАЧАТЬ"},
     {"Continue", "Продолжить"},
     {"Restart level", "Начать сначала"},
     {"Back to menu", "Вернуться в меню"},
     {"Try again", "Попробовать снова"},
     {"Select character", "Выбор персонажа"},
     {"Select", "Выбрать"},
     {"YOU ARE DEAD", "ВЫ МЕРТВЫ"},
     {"PAUSED", "ПАУЗА"}
     };

    public static string GetString(StringType title)
    {
        int lang = -1;
        if (language == SystemLanguage.English)
            lang = 0;
        else if (language == SystemLanguage.Russian)
            lang = 1;
        return localizedStrings[(uint)title, lang];
    }
}

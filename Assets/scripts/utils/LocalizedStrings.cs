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
    PausedText,
    Joystick,
    JoystickFree,
    JoystickStatic,
    GetCoins,
    Purchase,
    TouchToContinue,
    GreetingsText,
    TimerHelpText,
    LivesHelpText,
    PauseHelpText,
    SettingsText,
    LastInstructionsText,
    PurchaseProcessing,
    PurchaseSuccess,
    PurchaseFailure
}

public static class LocalizedStrings
{
    private static SystemLanguage language = Application.systemLanguage;

    private static string[,] localizedStrings =
    {
     {"Start game", "Начать игру"},
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
     {"GAME OVER", "GAME OVER"},
     {"PAUSED", "ПАУЗА"},
     {"Joystick", "Джойстик"},
     {"free", "свободный"},
     {"static", "статичный"},
     {"Get Coins", "Получить монеты"},
     {"Purchase", "Купить"},
     {"Tap to continue", "Коснитесь для продолжения"},
     {"You have to survive unitll end of the level.\nDodge obstacles!", "Вы должны выжить до конца уровня.\nИзбегайте препятствий!"},
     {"Level end countdown", "Время до конца уровня"},
     {"Lives count", "Количество жизней"},
     {"Pause button", "Кнопка паузы"},
     {"You can adjust control sensitivity, graphics quality and sounds in settings section in main menu", "Вы можете настроить чувствительность управления, качество графики и звуки в разделе настроек в главном меню"},
     {"To move player, move your finger anywhere on screen.\nGet ready - game begins after tap!", "Перемещайте палец по экрану, чтобы двигать игрока.\nПриготовьтесь - игра начнется после касания!"},
     {"Your purchase is being processed. . .", "Ваш заказ обрабатывается. . ."},
     };

    public static string GetString(StringType title)
    {
        int lang = 0;
        if (language == SystemLanguage.English)
            lang = 0;
        else if (language == SystemLanguage.Russian)
            lang = 1;
        return localizedStrings[(uint)title, lang];
    }
}

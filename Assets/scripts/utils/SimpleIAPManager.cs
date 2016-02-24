using UnityEngine;
using UnityEngine.Purchasing;

public class SimpleIAPManager : MonoBehaviour, IStoreListener 
{
    private IStoreController controller;
    private IExtensionProvider extensions;
    
    public GameObject WaitPanel;
    
    void Start()
    {
        if (controller == null)
            InitializePurchasing();
    }
    
    public void InitializePurchasing()
    {
        if (IsInitialized())
        {
            Debug.Log("IAP: Purchasing is initialized already");
            return;
        }
        Debug.Log("IAP: Starting initialization");
        var builder = ConfigurationBuilder.Instance(StandardPurchasingModule.Instance());
        // Добавляем то, что мы можем покупать
        builder.AddProduct("50_coins", ProductType.Consumable, new IDs
        {
           {"50_coins_apple", AppleAppStore.Name},
           {"50_coins_google", GooglePlay.Name},
           {"50_coins_winrt", WinRT.Name},
           {"50_coins_wp", WindowsPhone8.Name}
        });
        
        UnityPurchasing.Initialize(this, builder);
    }
    
    private bool IsInitialized()
    {
        return  ((controller != null) && (extensions != null));
    }
    
    // Этот методы вызывается при успешной инициализации сервиса покупок. 
    // Пока этот метод не вызвался, совершать покупки нельзя
    public void OnInitialized(IStoreController controller, IExtensionProvider extensions)
    {
        Debug.Log("IAP: initialization complete");
        
        this.controller = controller;
        this.extensions = extensions;
        
        Debug.Log("IAP: Availiable products: ");
        foreach (var product in controller.products.all) 
            Debug.Log ("IAP: " +  product.metadata.localizedTitle + ", " + product.metadata.localizedDescription + ", " + product.metadata.localizedPriceString);
    }
    
    // Метод вызывается при ошибке во время инициализации (вроде ошибки аутентификации и пр.).
    // Отсутствие подключения к интернету не является ошибкой
    public void OnInitializeFailed(InitializationFailureReason error)
    {
        Debug.LogError("IAP: " + error.ToString());
    }

    // Метод вызывается при ошибке во время покупки.  
    public void OnPurchaseFailed(Product i, PurchaseFailureReason p)
    {
        Debug.LogError("IAP: Failed to make a purchase for product " + i.metadata.localizedTitle + ". Reason: " + p.ToString());
    }
    
    // Этот метод вызывается, когда покупка совершена и завершилась успешно.
    // Именно здесь придется писать код, открывающий новые скины при успешной покупке
    public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs e)
    {
        Debug.Log("IAP: Purchase completed. Product: " + e.purchasedProduct.metadata.localizedTitle);
        if(e.purchasedProduct.definition.id == "50_coins")
        {
            CoinsManager.Balance += 50;
            Debug.Log("Balance: " + CoinsManager.Balance);
        }
        WaitPanel.SetActive(false);
        return PurchaseProcessingResult.Complete;
    }
    
    // Этот метод можно вызвать по нажатию кнопки "Купить" 
    public void InitializePurchase(string productId)
    {
        WaitPanel.SetActive(true);
        controller.InitiatePurchase(productId);
    }
    
    public void BuyCoins()
    {
        controller.InitiatePurchase("50_coins");
    }
    
    // Этот метод вызывается по нажатию кнопки "восстановить покупки" на iOS
    // (другие платформы делают это автоматически) 
    public void RestoreTransactions()
    {
        extensions.GetExtension<IAppleExtensions>().RestoreTransactions (result =>
        {
           if (result)
           {
               Debug.Log("IAP: Restore initiated");
           } 
           else 
           {
               Debug.LogError("IAP: Restore failed");
           }
        });
    }
}

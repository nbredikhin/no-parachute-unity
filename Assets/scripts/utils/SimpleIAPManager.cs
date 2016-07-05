using UnityEngine;
using UnityEngine.Purchasing;

public class SimpleIAPManager : MonoBehaviour, IStoreListener 
{
    private IStoreController controller;
    private IExtensionProvider extensions;
    
    public GameObject WaitPanel;
    public GameObject PanelText;
    public GameObject Button;
    
    public float RequestTimeoutTime = 10;
    private float requestTimeoutTimer = 0;
    private bool isPurchasing = false;
    public static string IAP_ID = "50_rings";
    
    void Start()
    {
        if (controller == null)
            InitializePurchasing();
            
        UnsetWarning();
    }
    
    private void SetWarning()
    {
        PanelText.GetComponent<UnityEngine.UI.Text>().text = LocalizedStrings.GetString("characters_menu_iap_timeout");
        Button.SetActive(true);
    }
    
    private void UnsetWarning()
    {
        PanelText.GetComponent<UnityEngine.UI.Text>().text = LocalizedStrings.GetString("characters_menu_iap_processing");
        Button.SetActive(false);
        requestTimeoutTimer = 0;
    }
    
    void Update()
    {
        if (isPurchasing)
        {
            requestTimeoutTimer += Time.deltaTime;
            Debug.Log(requestTimeoutTimer);
            if (requestTimeoutTimer > RequestTimeoutTime)
            {
                SetWarning();
            }
        }
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
        builder.AddProduct(IAP_ID, ProductType.Consumable, new IDs
        {
           {IAP_ID + "_apple", AppleAppStore.Name},
           {IAP_ID + "_google", GooglePlay.Name},
           {IAP_ID + "_winrt", WinRT.Name},
           {IAP_ID + "_rings_wp", WindowsPhone8.Name}
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
        WaitPanel.SetActive(false);
        isPurchasing = false;
        UnsetWarning();
        Debug.LogError("IAP: Failed to make a purchase for product " + i.metadata.localizedTitle + ". Reason: " + p.ToString());
    }
    
    public void CancelPurchase()
    {
        WaitPanel.SetActive(false);
        isPurchasing = false;   
        UnsetWarning();
    }
    
    // Этот метод вызывается, когда покупка совершена и завершилась успешно.
    // Именно здесь придется писать код, открывающий новые скины при успешной покупке
    public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs e)
    {
        Debug.Log("IAP: Purchase completed. Product: " + e.purchasedProduct.metadata.localizedTitle);
        if(e.purchasedProduct.definition.id == IAP_ID)
        {
            CoinsManager.Balance += 50;
            Debug.Log("Balance: " + CoinsManager.Balance);
        }            
        WaitPanel.SetActive(false);
        UnsetWarning();
        isPurchasing = false;
        return PurchaseProcessingResult.Complete;
    }
    
    // Этот метод можно вызвать по нажатию кнопки "Купить" 
    public void InitializePurchase(string productId)
    {
        UnsetWarning();
        WaitPanel.SetActive(true);
        isPurchasing = true;
        controller.InitiatePurchase(productId);
    }
    
    public void BuyCoins()
    {
        InitializePurchase(IAP_ID);
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

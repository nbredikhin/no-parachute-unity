using UnityEngine;
using System.Collections.Generic;

public class PlaneBehaviour : MonoBehaviour 
{
	public Dictionary<GameObject, PlaneProperties> layers; 
	public GameObject LayerPrefab;
	public Texture2D holeMask;
	public bool Visible
	{
		get 
		{
			var childRenderers = gameObject.GetComponentsInChildren<MeshRenderer>();
			bool res = true;
			foreach (var renderer in childRenderers)
				res &= renderer.enabled;
			return res;
		}
		set 
		{
			var childRenderers = gameObject.GetComponentsInChildren<MeshRenderer>();
			foreach (var renderer in childRenderers)
				renderer.enabled = value;
		}
	}
	
	void Start () 
	{
		
	}
	
	public void Fade(float speed)
	{
		var childRenderers = gameObject.GetComponentsInChildren<MeshRenderer>();
		foreach (var renderer in childRenderers)
		{
			var material = renderer.material;
			material.color = material.color - new Color(0, 0, 0, speed);
		}				
	}

	public void Setup(List<PlaneProperties> layerProps)
	{
		layers = new Dictionary<GameObject, PlaneProperties>();
        for (int i = 0; i < layerProps.Count; ++i)
		{
            var currentLayerProps = layerProps[i];
			var newObject = Instantiate<GameObject>(LayerPrefab);
            newObject.name = "layer_" + i.ToString();
			newObject.GetComponent<MeshRenderer>().material.mainTexture = currentLayerProps.MainTexture;
			newObject.transform.SetParent(gameObject.transform, false);
            
            newObject.AddComponent(System.Type.GetType(currentLayerProps.MovementScriptName));
            currentLayerProps.MovementScript = newObject.GetComponent<BaseMovement>();
            currentLayerProps.MovementScript.Setup(currentLayerProps.MovementSpeed, currentLayerProps.RotationSpeed);
            
			layers.Add(newObject, currentLayerProps);
		}
        Respawn();
	}
    
    public void ReassignLayers(Dictionary<GameObject, PlaneProperties> original)
    {
        layers = new Dictionary<GameObject, PlaneProperties>();
        int i = 0;
        foreach (var currentLayerPair in original)
        {
            var layerProperties = currentLayerPair.Value;
            layers.Add(transform.GetChild(i++).gameObject, layerProperties);
        }
    }
    
    public void Respawn()
    {
		int i = 0;
        foreach (var currentLayerPair in layers)
        {
            var layerProperties = currentLayerPair.Value;
            var layerGameObject = currentLayerPair.Key;
            
            float randomPosX = Random.Range(layerProperties.SpawnMinimum.x, layerProperties.SpawnMaximum.x);
            float randomPosY = Random.Range(layerProperties.SpawnMinimum.y, layerProperties.SpawnMaximum.y);
            
            layerGameObject.transform.localPosition = new Vector3(randomPosX, randomPosY, 0);
			layerGameObject.transform.position += new Vector3(0, -0.01f * (i++), 0);
        }
    }
    
    public Color CreateHole(Vector3 position)
    {
        Color layerColor = Color.red;
        
        foreach (var currentLayerPair in layers)
        {
			var layerGameObject = currentLayerPair.Key;
			var meshRenderer = currentLayerPair.Key.GetComponent<MeshRenderer>();
			var texture = (Texture2D)meshRenderer.material.mainTexture;
			
            var x = position.x - layerGameObject.transform.position.x;
			var y = position.z - layerGameObject.transform.position.z;
			var r = Utils.RotateVector2(new Vector2(x, y), layerGameObject.transform.eulerAngles.y);
			
			x = Mathf.Floor((r.x + layerGameObject.transform.localScale.x / 2) / layerGameObject.transform.localScale.x * texture.width);
			y = Mathf.Floor((r.y + layerGameObject.transform.localScale.y / 2) / layerGameObject.transform.localScale.y * texture.height);
			
			// Создание новой текстуры, чтобы текстура не изменялась глобально
			var newTexture = (Texture2D) GameObject.Instantiate(texture);
			var color = new Color(0, 0, 0, 0);
			for (int cx = 0; cx < holeMask.width; cx++)
			{
				for (int cy = 0; cy < holeMask.height; cy++)
				{
					if (holeMask.GetPixel(cx, cy).a == 0)
					{
						int textureX = cx - holeMask.width / 2 + (int) x;
						int textureY = cy - holeMask.height / 2 + (int) y;
                        var pixelColor = newTexture.GetPixel(textureX, textureY);
                        if (pixelColor.a > 0 && layerColor == Color.red)
                        {
                            layerColor = pixelColor;
                        }
						newTexture.SetPixel(textureX, textureY, color);
                        
					}
				}
			}
			
            newTexture.Apply(false, false);
			meshRenderer.material.mainTexture = newTexture;
        }
        
        return layerColor;
    }
	
	public GameObject HitTestPoint(Vector3 point)
	{
		foreach (var currentLayerPair in layers)
		{
			var layerGameObject = currentLayerPair.Key;
			var layerProperties = currentLayerPair.Value;
			
			var texture = layerProperties.MainTexture as Texture2D;
			
			var x = point.x - layerGameObject.transform.position.x;
			var y = point.z - layerGameObject.transform.position.z;
			
			var r = Utils.RotateVector2(new Vector2(x, y), layerGameObject.transform.eulerAngles.y);
           
			x = Mathf.Floor((r.x + layerGameObject.transform.localScale.x / 2) / layerGameObject.transform.localScale.x * texture.width);
			y = Mathf.Floor((r.y + layerGameObject.transform.localScale.y / 2) / layerGameObject.transform.localScale.y * texture.height);
            
            if (x < 0 || x > texture.width || y < 0 || y > texture.height)
                continue;
            
			if (texture.GetPixel((int)x, (int)y).a > 0)
				return layerGameObject;
		}
		return null;	
	}
	
	void Update () 
	{
	}
}

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
	
	public void Setup(List<PlaneProperties> layerProps)
	{
		layers = new Dictionary<GameObject, PlaneProperties>();
		foreach (var currentLayerProps in layerProps)
		{
			var newObject = Instantiate<GameObject>(LayerPrefab);
			newObject.GetComponent<MeshRenderer>().material.mainTexture = currentLayerProps.MainTexture;
			newObject.transform.SetParent(gameObject.transform, false);
			layers.Add(newObject, currentLayerProps);
			
			// TODO: Сделать привязку скриптов
		}
	}
	
    public void CreateHole(Vector3 position)
    {
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
						newTexture.SetPixel(textureX, textureY, color);
					}
				}
			}
			
            newTexture.Apply(false, false);
			meshRenderer.material.mainTexture = newTexture;
        }
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
			
			if (texture.GetPixel((int)x, (int)y).a > 0)
				return layerGameObject;
		}
		return null;	
	}
	
	void Update () 
	{
		if (layers == null)
			return;
		foreach (var currentLayer in layers)
		{
			var layerGameObject = currentLayer.Key;
			var layerProperties = currentLayer.Value;
			
			layerGameObject.transform.Rotate(0, 0, layerProperties.RotationSpeed * Time.deltaTime);
		}
	}
}

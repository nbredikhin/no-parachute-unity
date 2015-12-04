using UnityEngine;
using System.Collections.Generic;

public class PlaneBehaviour : MonoBehaviour 
{
	public Dictionary<GameObject, PlaneProperties> layers; 
	public GameObject LayerPrefab;
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
	
	public bool HitTestPoint(Vector3 point)
	{
		foreach (var currentLayerPair in layers)
		{
			var layerGameObject = currentLayerPair.Key;
			var layerProperties = currentLayerPair.Value;
			
			var texture = layerProperties.MainTexture as Texture2D;
			
			var x = point.x;
			var y = point.z;
			
			x -= layerGameObject.transform.position.x;
			y -= layerGameObject.transform.position.z;
			
			var sin = Mathf.Sin(layerGameObject.transform.eulerAngles.y * Mathf.Deg2Rad);
			var cos = Mathf.Cos(layerGameObject.transform.eulerAngles.y * Mathf.Deg2Rad);
			
			x = x * cos - y * sin;
			y = x * sin - y * cos;
			
			x = Mathf.Floor((x + layerGameObject.transform.localScale.x / 2) / layerGameObject.transform.localScale.x * texture.width);
			y = Mathf.Floor((1 - (y + layerGameObject.transform.localScale.y / 2) / layerGameObject.transform.localScale.y) * texture.height);
			
			// Debug.Log(x + " " + y);
			
			if (texture.GetPixel((int)x, (int)y).a > 0)
				return true;
		}
		return false;	
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

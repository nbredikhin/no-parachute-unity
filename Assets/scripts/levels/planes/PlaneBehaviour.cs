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
	
	void Update () 
	{
		if (layers == null)
			return;
		foreach (var currentLayer in layers)
		{
			var layerGameObject = currentLayer.Key;
			var layerProperties = currentLayer.Value;
			
			// layerGameObject.transform.Translate(layerProperties.MovementSpeed * Time.deltaTime);
			layerGameObject.transform.Rotate(0, 0, layerProperties.RotationSpeed * Time.deltaTime);
		}
	}
}

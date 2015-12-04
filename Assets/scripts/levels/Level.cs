using UnityEngine;
using System.IO;
using Newtonsoft.Json;
using System.Collections.Generic;

// Объект уровня для сериализации
public class Level
{
	public int Number;
	public List< List<PlaneProperties> > Planes;
	public float CameraRotationSpeed;
	public float FallingSpeed;
	
	public bool LoadLevel(TextAsset file)
	{
		return LoadLevel(file.text);
	}
	
	public bool LoadLevel(string level_str)
	{
		JsonTextReader reader = new JsonTextReader(new StringReader(level_str));
			
		string propName = "";
		object val = null;
		while (reader.Read())
		{	
			var tokenType = reader.TokenType;
			if (tokenType == JsonToken.PropertyName)
			{
				propName = reader.Value.ToString(); 
			}
			else 
			{
				// Все простые типы просто ининцализируем
				if (tokenType == JsonToken.Integer || tokenType == JsonToken.String || tokenType == JsonToken.Float)
				{
					val = reader.Value;
				}
				else
				{
					// Начала массивов - создаем соотвтетствующие массивы
					if (tokenType == JsonToken.StartArray)
					{
						if (Planes == null)
						{
							val = new List< List<PlaneProperties> >();
						}
						else 
						{
							propName = "Layers";
							val = new List<PlaneProperties>();
						}
					}
					else if (tokenType == JsonToken.StartObject)
					{
						if (Planes == null)
						{
							propName = "";
						}
						else
						{ 
							propName = "Layer";
							val = new PlaneProperties();
						}
					}
					else if (tokenType == JsonToken.EndArray || tokenType == JsonToken.EndObject || tokenType == JsonToken.Comment)
					{
						propName = "";
					}
				}
				SetProperty(propName, val);
			}
		}
		return true;
	}
	
	private void SetProperty(string propName, object val)
	{
		int len, len2;
		float buf;
		switch (propName)
		{
			case "Number":
				int.TryParse(val.ToString(), out Number);
			break;
			case "FallingSpeed":
				float.TryParse(val.ToString(), out FallingSpeed);
			break;
			case "CameraRotationSpeed":
				float.TryParse(val.ToString(), out CameraRotationSpeed);
			break;
			case "Planes":
				Planes = (List< List<PlaneProperties> >)val;
			break;
			case "Layer":
				Planes[Planes.Count - 1].Add((PlaneProperties)val);
			break;
			case "Layers":
				Planes.Add((List<PlaneProperties>)val);
			break;
			case "SpeedX":
				len = Planes.Count - 1;
				len2 = Planes[len].Count - 1;
				
				float.TryParse(val.ToString(), out buf);
				Planes[len][len2].SpeedX = buf;
			break;
			case "SpeedY":
				len = Planes.Count - 1;
				len2 = Planes[len].Count - 1;
				
				float.TryParse(val.ToString(), out buf);
				Planes[len][len2].SpeedY = buf;
			break;
			case "SpeedZ":
				len = Planes.Count - 1;
				len2 = Planes[len].Count - 1;
				
				float.TryParse(val.ToString(), out buf);
				Planes[len][len2].SpeedZ = buf;
			break;
			case "TexturePath":
				len = Planes.Count - 1;
				len2 = Planes[len].Count - 1;
				
				Planes[len][len2].TexturePath = val.ToString();
				Debug.Log(Planes[len][len2].TexturePath);
			break;
			case "RotationSpeed":
				len = Planes.Count - 1;
				len2 = Planes[len].Count - 1;
				
				float.TryParse(val.ToString(), out Planes[len][len2].RotationSpeed);
			break;
			case "":
				// Токен закрытия. Ничего не делать
			break;
			default:
				Debug.LogError("Wrong property name!");
			break;
		}
	}
}

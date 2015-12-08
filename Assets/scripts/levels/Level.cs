using UnityEngine;
using System.Collections.Generic;

using SimpleJSON;

// Объект уровня для сериализации
public class Level
{
	public int Number;
	public List< List<PlaneProperties> > Planes;
	public float CameraRotationSpeed;
	public float FallingSpeed;
	
	public bool LoadLevel(TextAsset file)
	{
		string jsonStr = file.text;
		
		var parsedJson = JSON.Parse(jsonStr);
		
		Number = parsedJson["Number"].AsInt;
		CameraRotationSpeed = parsedJson["CameraRotationSpeed"].AsFloat;
		FallingSpeed = parsedJson["FallingSpeed"].AsFloat;
		
		Planes = new List< List<PlaneProperties> >();
		var planesArray = parsedJson["Planes"].AsArray;
		
		for (int i = 0; i < planesArray.Count; ++i)
		{
			Planes.Add(new List<PlaneProperties>());
			var propsArray = planesArray[i];
			
			for (int j = 0; j < propsArray.Count; ++j)
			{
				var currentProp = new PlaneProperties();
				
				currentProp.RotationSpeed = propsArray[j]["RotationSpeed"].AsFloat;
				currentProp.TexturePath = "levels/" + Number.ToString() + "/planes/" + propsArray[j]["TexturePath"];
				currentProp.SpeedX = propsArray[j]["SpeedX"].AsFloat;
				currentProp.SpeedY = propsArray[j]["SpeedY"].AsFloat;
				currentProp.SpeedZ = propsArray[j]["SpeedZ"].AsFloat;
				
				Planes[i].Add(currentProp);
			}
		}
		
		return true;
	}
	
	public string SerializeLevel()
	{
		string result = "{}";
		
		var json = JSON.Parse(result);
		json["FallingSpeed"].AsFloat = FallingSpeed;
		json["CameraRotationSpeed"].AsFloat = CameraRotationSpeed;
		
		json["Planes"] = new JSONArray();
		
		for (int i = 0; i < Planes.Count; ++i)
		{
			json["Planes"][-1] = new JSONArray();
			for (int j = 0; j < Planes[i].Count; ++j)
			{
				json["Planes"][i][j]["RotationSpeed"].AsFloat = Planes[i][j].RotationSpeed;
				json["Planes"][i][j]["SpeedX"].AsFloat = Planes[i][j].SpeedX;
				json["Planes"][i][j]["SpeedY"].AsFloat = Planes[i][j].SpeedY;
				json["Planes"][i][j]["SpeedZ"].AsFloat = Planes[i][j].SpeedZ;
				
				string texturePath = Planes[i][j].TexturePath;
				// Не храним полный путь до текстуры
				string prefix = "levels/" + Number.ToString() + "/planes/";
				if (texturePath.Contains(prefix))
					texturePath = texturePath.Substring(prefix.Length);
				json["Planes"][i][j]["TexturePath"] = texturePath;
			}
		}
		
		result = json.ToString("\t");
		return result;
	}
}

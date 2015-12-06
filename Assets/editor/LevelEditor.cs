using System.IO;
using System.Collections.Generic;

using UnityEngine;
using UnityEditor.AnimatedValues;
using UnityEditor;

using Newtonsoft.Json;

public class LevelEditor : EditorWindow 
{    
	private Level levelSetup;
	private int arrayIndexer;
	private AnimBool faded;
	private Vector2 scrollPos;
	
	[MenuItem("Window/Редактор уровней")]
	public static void ShowWindow () 
	{
		EditorWindow.GetWindow(typeof(LevelEditor));
		
	}
	
	void OnEnable()
	{
		if (levelSetup == null)
		{
			levelSetup = new Level();
			levelSetup.Planes = new List< List<PlaneProperties>>();	
		}
		faded = new AnimBool(true);
		faded.speed = 0;
	}
	
	void OnGUI () 
	{
		GUILayout.Label ("Настройки уровня", EditorStyles.boldLabel);
		
		levelSetup.Number = EditorGUILayout.IntField("Номер уровня", levelSetup.Number);
		if (levelSetup.Number < 0)
			levelSetup.Number = 0;
		levelSetup.FallingSpeed = (float)EditorGUILayout.DoubleField("Скорость падения", levelSetup.FallingSpeed);
		levelSetup.CameraRotationSpeed = (float)EditorGUILayout.DoubleField("Скорость вращения", levelSetup.CameraRotationSpeed);
		
		EditorGUILayout.Space();
		GUILayout.Label ("Плоскости", EditorStyles.boldLabel);
		arrayIndexer = levelSetup.Planes.Count;
		
		arrayIndexer = EditorGUILayout.IntField("Количество плоскостей", arrayIndexer);
		if (arrayIndexer < 0)
			arrayIndexer = 0;
		if(arrayIndexer != levelSetup.Planes.Count)
		{
            while(arrayIndexer > levelSetup.Planes.Count)
			{
                levelSetup.Planes.Add(new List<PlaneProperties>());
				levelSetup.Planes[levelSetup.Planes.Count - 1].Add(new PlaneProperties());	
				levelSetup.Planes[levelSetup.Planes.Count - 1][0].TexturePath = (levelSetup.Planes.Count).ToString();
            }
            while(arrayIndexer < levelSetup.Planes.Count)
			{
				levelSetup.Planes.RemoveAt(levelSetup.Planes.Count - 1);
            }
        }
		scrollPos = EditorGUILayout.BeginScrollView(scrollPos, false, true);
			var fade_layers = new AnimBool(true);
			fade_layers.speed = 0;	
			
			for (int i = 0, indexer = 0; i < arrayIndexer; ++i)
			{
				GUILayout.Box("", new GUILayoutOption[]{GUILayout.ExpandWidth(true), GUILayout.Height(1)});
				fade_layers.target = true;
				indexer = levelSetup.Planes[i].Count;
				indexer = EditorGUILayout.IntField("Количество слоев", indexer);
				if (indexer < 0)
					indexer = 0;
				if(indexer != levelSetup.Planes[i].Count)
				{
            		while(indexer > levelSetup.Planes[i].Count)
					{
                		levelSetup.Planes[i].Add(new PlaneProperties());
            		}
            		while(indexer < levelSetup.Planes[i].Count)
					{
						levelSetup.Planes[i].RemoveAt(levelSetup.Planes[i].Count - 1);
            		}
        		}
				EditorGUILayout.Space();
				// Layer			
				if (EditorGUILayout.BeginFadeGroup(fade_layers.faded))
				{
					for (int j = 0; j < indexer; ++j)
					{	
						if (levelSetup.Planes[i][j].TexturePath == "")
						{
							levelSetup.Planes[i][j].TexturePath = (i + 1).ToString();
						}
						levelSetup.Planes[i][j].TexturePath = EditorGUILayout.TextField("Имя текстуры", levelSetup.Planes[i][j].TexturePath);
						levelSetup.Planes[i][j].MovementSpeed = EditorGUILayout.Vector3Field("Скорость движения", levelSetup.Planes[i][j].MovementSpeed);
						levelSetup.Planes[i][j].RotationSpeed = (float)EditorGUILayout.DoubleField("Скорость вращения", levelSetup.Planes[i][j].RotationSpeed);
						EditorGUILayout.Space();
					}
				}					
				EditorGUILayout.EndFadeGroup();
				
			}
		EditorGUILayout.EndScrollView();
		if (GUILayout.Button("Сохранить"))
		{
			string s = levelSetup.SerializeLevel();
			Debug.Log(s);
			File.WriteAllText("Assets/resources/levels/" + levelSetup.Number + "/level.json", s);
		}
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class Loader {
	public enum Scene {
		MainMenuScene,
		GameScene,
		LoadingScene,
	}


	private static Scene s_targetScene;
	public static void Load(Scene a_targetScene){
		//Cache the target scene.
		s_targetScene = a_targetScene;

		//Load the loading scene.
		SceneManager.LoadScene(Scene.LoadingScene.ToString());
	}

	public static void LoaderCallback() {
		//Load the final cached scene.
		SceneManager.LoadScene(s_targetScene.ToString());
	}
}
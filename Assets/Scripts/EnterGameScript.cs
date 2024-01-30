using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EnterGameScript : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        
    }
   
    public void LoadMainScreen()
    {
        SceneManager.LoadScene("MainScene"); // Replace "MainScene" with the name of your main scene
    }
}

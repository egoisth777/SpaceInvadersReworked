using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GlobalController : MonoBehaviour
{
    [Header("Global")]
    public bool isGameOver;

    [Header("Player Ship")]
    private GameObject curPlayerShip;

    public int InitLife;
    private int RemainingLife;
    public int PlayerScore;
    public Text scoreGUI;

    public Vector3 PlayerShipInitPosition;
    public GameObject PlayerShip;
    
    [Header("Alien Invader")]
    public GameObject AlienUFO;
    private GameObject currentUFO;

    public Vector3 UFOInitPos;

    public GameObject[] AlienInvaders;
    public float alienMoveSpeed;

    [Header("Rocks")]
    public GameObject Rock;
    public int rockCount;
    public Vector3 rockInitPos;
    public float rockInterval;
    private List<GameObject> rockList;

    // private memebers
    private LifeIcons lifeIcons;
    private Text GameOverText;

    // Start is called before the first frame update
    void Start()
    {
        lifeIcons = GameObject.FindObjectOfType<LifeIcons>();
        GameOverText = GameObject.Find("GameOverText").GetComponent<Text>();
        rockList = new List<GameObject>(); // create a list of rock that is destructable
        scoreGUI = GetComponentInChildren<Text>();
        OnGameStart();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.F12))
        {
            Reset();
        }

        if(!isGameOver)
        {
            
        }
    }

    private void OnGameStart()
    {
        Reset();
    }

    public void OnGameOver()
    {
        // TODO: Display "GameOver"
        if(!isGameOver)
        {
            GameOverText.text = "Game Over";
            Invoke("SpawnDelayLose", 5);
            
        }
    }

    public void OnGameWin()
    {
        if (!isGameOver)
        {
            GameOverText.text = "Game Win";
            Invoke("SpawnDelayWin", 5);
        }
    }

    private void SpawnDelayLose()
    {
        isGameOver = true;
        SceneManager.LoadScene("MainTitlePage");
    }
    private void SpawnDelayWin()
    {
        isGameOver = true;
        SceneManager.LoadScene("MainTitlePage");
    }

    public void Reset()
    {
        isGameOver = false;
        GameOverText.text = "";
        GameObject.Find("InvaderController").GetComponent<InvaderRowController>().Reset();

        PlayerScore = 0;
        RemainingLife = InitLife;

        scoreGUI.text = PlayerScore.ToString();

        //Initiate PlayerShip
        InitPlayerShip();

        lifeIcons.Reset(InitLife);

        // Inititiate Rocks
        InitRocks();

        CancelInvoke("GenUFO");
        float randTime = Random.Range(7.0f, 15.0f);
        Invoke("GenUFO", randTime);
    }

    private void InitPlayerShip()
    {
        if(curPlayerShip != null)
        {
            Destroy(curPlayerShip);
        }
        curPlayerShip = Instantiate(PlayerShip, PlayerShipInitPosition, Quaternion.identity) as GameObject;
    }

    private void InitRocks()
    {
        for (int i = 0; i < rockList.Count; i++)
        {
            if (rockList[i] != null)
            {
                Destroy(rockList[i]);
            }
        }
        rockList.Clear();

        Vector3 rock_pos = rockInitPos;
        for (int i = 0; i < rockCount; i++) 
        {
            GameObject obj = Instantiate(Rock, rock_pos, Quaternion.identity) as GameObject;
            rockList.Add(obj);
            rock_pos.x += rockInterval;
        }
    }

    public void IncreasePoint(int point)
    {
        PlayerScore += point;

        scoreGUI.text = PlayerScore.ToString();
    }

    /// <summary>
    /// Handles the event when the player's ship dies.
    /// Play the death sound for roughly about 5 seconds
    /// </summary>
    /// <param name="params">No parameters needed.</param>
    public void OnPlayerDead()
    {
        RemainingLife -= 1;
        lifeIcons.ReduceLife();

        if (RemainingLife <= 0)
        {
            OnGameOver();
        }
        else
        {
            InitPlayerShip();
        }
    }

    private void GenUFO()
    {
        if (!isGameOver)
        {
            currentUFO = Instantiate(AlienUFO, UFOInitPos, Quaternion.identity) as GameObject;
            currentUFO.GetComponent<Rigidbody>().AddForce(new Vector3(200.0f, 0.0f, 0.0f));

            Invoke("DestroyUFO", 6);

            float randTime = Random.Range(15.0f, 30.0f);
            Invoke("GenUFO", randTime);
        }
    }
    private void DestroyUFO()
    {
        if (currentUFO != null)
        {
            Destroy(currentUFO);
        }
    }
}

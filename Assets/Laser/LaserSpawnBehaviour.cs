using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserSpawnBehaviour : MonoBehaviour
{
    public float shotCooldown = 3.0f;
    private float shotCooldownTimer = 3.0f;
    public GameObject laserPrefab;
    // Update is called once per frame
    void Update()
    {
        shotCooldownTimer += Time.deltaTime; 
        // only shoot a laser when cooldown has expired
        if(shotCooldown < shotCooldownTimer)
        {
            // spawn laser and shoot straight forward from the transform that this script is attached to 
            // (laser movement is handled by the prefab) 
            Instantiate(laserPrefab, transform.position, transform.rotation);
            // reset cooldown
            shotCooldownTimer = 0.0f; 
        }
    }
}

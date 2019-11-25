using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserMovementBehaviour : MonoBehaviour
{
    public float laserSpeed = 100.0f; 

    void Update()
    {
        transform.position += transform.forward * Time.deltaTime * laserSpeed; 
    }
}

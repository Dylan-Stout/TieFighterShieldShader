using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserMovementBehaviour : MonoBehaviour
{
    public float laserSpeed = 400.0f;
    public float projectileBias = 10.0f;

    void Update()
    {
        float distance = Time.deltaTime * laserSpeed;
        transform.position += transform.forward * Time.deltaTime * laserSpeed;

        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;

        Debug.DrawRay(transform.position, transform.forward * (distance + projectileBias), Color.blue);
        if(Physics.Raycast(ray, out hit, distance + projectileBias))
        {
            hit.collider.SendMessage("OnProjectileHit", hit.point, SendMessageOptions.DontRequireReceiver);
            Destroy(gameObject);
        }
    }
}

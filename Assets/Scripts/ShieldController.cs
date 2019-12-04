using UnityEngine;
using System.Collections.Generic;
using System.Linq;

[ExecuteInEditMode]
public class ShieldController : MonoBehaviour
{
    [SerializeField]
    Material shieldMaterial;

    [SerializeField]
    [Range(0.5f,2.0f)]
    float hitFXSpeed;

    private static readonly Vector4[] emptyVectorArray = { Vector4.zero };

    // Add to create shield hit FX
    // x,y,z location  -  w time and distance of FX (w needs to be set at 0 when new pt added)
    public List<Vector4> shieldPointsToRender;

    private void Awake()
    {
        shieldPointsToRender = new List<Vector4>();
    }

    /// <summary>
    /// Handles shader input and shield hit locations
    /// </summary>
    void Update()
    {
        // test points at random
        //float xRand = Random.Range(-0.5f, 0.5f);
        //float yRand = Random.Range(-0.5f, 0.5f);
        //float zRand = Random.Range(-0.5f, 0.5f);
        //shieldPointsToRender.Add(new Vector4(xRand, yRand, zRand, 0));

        PlayHitFX();

        shieldMaterial.SetInt("_ShieldPointSize", shieldPointsToRender.Count);

        // Shader needs to have at least one element in the array at all times
        if(shieldPointsToRender.Count > 0)
            shieldMaterial.SetVectorArray("_ShieldPoints", shieldPointsToRender);
        else
            shieldMaterial.SetVectorArray("_ShieldPoints", emptyVectorArray);

        HitDecay();
    }

    /// <summary>
    /// Increases the w variable of the hit location over Time.deltaTime.
    /// </summary>
    void PlayHitFX()
    {
        for (int i = 0; i < shieldPointsToRender.Count; i++)
        {
            float x = shieldPointsToRender[i].x;
            float y = shieldPointsToRender[i].y;
            float z = shieldPointsToRender[i].z;
            float w = shieldPointsToRender[i].w + Time.deltaTime * hitFXSpeed;

            shieldPointsToRender[i] = new Vector4(x,y,z,w);
        }
    }

    /// <summary>
    /// Iterates through the currents points and removes them from the list 
    /// once they have finished playing out.
    /// </summary>
    void HitDecay()
    {
        for (int i = 0; i < shieldPointsToRender.Count; i++)
        {
            if (shieldPointsToRender[i].w > 1.0f)
            {
                shieldPointsToRender.RemoveAt(i);
                i--;
            }
        }
    }

    /// <summary>
    /// Adds a point of impact on the shield to show FX
    /// </summary>
    /// <param name="inc_impactPoint"></param>
    void OnProjectileHit(Vector3 inc_impactPoint)
    {
        inc_impactPoint = this.transform.worldToLocalMatrix * inc_impactPoint;
        Vector4 impactPoint = new Vector4(inc_impactPoint.x, inc_impactPoint.y, inc_impactPoint.z, 0);
        shieldPointsToRender.Add(impactPoint);
    }

    private void OnCollisionEnter(Collision collision)
    {
        Destroy(collision.gameObject); 
    }
}

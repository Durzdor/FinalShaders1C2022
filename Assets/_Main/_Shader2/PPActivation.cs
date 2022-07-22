using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PPActivation : MonoBehaviour
{
    [SerializeField] private PPSwitcher ppSwitcher;
    
    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("PortalDistortion"))
        {
            print("testStay");
            ppSwitcher.enabled = true;
            ppSwitcher.intensity = 1f;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("PortalDistortion"))
        {
            print("testExit");
            ppSwitcher.intensity = 0f;
            ppSwitcher.enabled = false;
        }
    }
}

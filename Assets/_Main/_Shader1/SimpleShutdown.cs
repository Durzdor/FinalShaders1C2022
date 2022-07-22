using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleShutdown : MonoBehaviour
{
    [SerializeField] private GameObject go;
    [SerializeField] private PPSwitcher PpSwitcher;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            PpSwitcher.enabled = !go.activeInHierarchy;
            go.SetActive(!go.activeInHierarchy);
           
        }
    }
}

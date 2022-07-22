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
            go.SetActive(!go.activeInHierarchy);
            PpSwitcher.enabled = !go.activeInHierarchy;
        }
    }
}

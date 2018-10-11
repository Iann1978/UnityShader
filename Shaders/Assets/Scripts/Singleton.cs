using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// 单例模式模版
/// </summary>
/// <typeparam name="T"></typeparam>
public class Singleton<T> where T : class, new()
{
    static T ins;

    public static T me
    {
        get
        {
            if (ins != null)
                return ins;
            ins = new T();
            return ins;
        }
    }
}


public abstract class SingletonMonoBehaviourNoCreate<T> : MonoBehaviour where T : SingletonMonoBehaviourNoCreate<T>
{
    private static T this_obj = null;
    public static T me
    {
        get
        {
            return this_obj;
        }
    }

    public virtual void Awake()
    {
        //		Debug.Log("singleton  awake before"+typeof(T));
        if (this_obj == null)
        {
            DontDestroyOnLoad(this.gameObject);
            this_obj = this as T;
        }
        //		Debug.Log("singleton  awake end "+this_obj);
    }

    public virtual void Init()
    {

    }

    private void OnApplicationQuit()
    {
        //this_obj = null;
    }

    public static void ReleaseInstance()
    {
        if (this_obj != null)
        {
            Destroy(this_obj.gameObject);
            this_obj = null;
        }
    }
}


public abstract class SingletonMonoBehaviour<T> : MonoBehaviour where T : SingletonMonoBehaviour<T>
{
    private static T this_obj = null;

    public static T me
    {
        get
        {
            CreateInstance();
            return this_obj;
        }
    }

    private void Awake()
    {
        if (this_obj == null)
        {
            this_obj = this as T;
            this_obj.Init();
        }
    }

    protected virtual void Init()
    {

    }
    virtual public void Show()
    {
        if (this.gameObject.activeSelf == false)
        {
            this.gameObject.SetActive(true);
        }
    }
    virtual public void Hide()
    {
        if (this.gameObject.activeSelf == true)
        {
            this.gameObject.SetActive(false);
        }

    }
    private void OnApplicationQuit()
    {
        this_obj = null;
    }

    public static void CreateInstance()
    {
        if (this_obj != null)
            return;

        T[] managers = GameObject.FindObjectsOfType(typeof(T)) as T[];
        if (managers.Length != 0)
        {
            if (managers.Length == 1)
            {
                this_obj = managers[0];
                this_obj.gameObject.name = typeof(T).Name;
                DontDestroyOnLoad(this_obj.gameObject);
                return;
            }
            else
            {
                Debug.Log("You have more than one " + typeof(T).Name + " in the scene. You only need 1, it's a singleton!");
                foreach (T manager in managers)
                {
                    Destroy(manager.gameObject);
                }
            }
        }

        GameObject gO = new GameObject(typeof(T).Name, typeof(T));
        //gO.transform.parent = GameObject.Find("UI Root").transform;
        this_obj = gO.GetComponent<T>();
        this_obj.Init();
        DontDestroyOnLoad(gO);
    }

    public static void ReleaseInstance()
    {
        if (this_obj != null)
        {
            Destroy(this_obj.gameObject);
            this_obj = null;
        }
    }
}

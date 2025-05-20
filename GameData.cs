using Godot;
using System;

//for settings and stuff
public class GameData
{



    public string saveFileVersion = GlobalManager.gameVersion;

    //audio settings
    public float masterVolume = 1.0f;
    public float sfxVolume = 1.0f;
    public float musicVolume = 1.0f;

    public float default_masterVolume = 1.0f;
    public float default_sfxVolume = 1.0f;
    public float default_musicVolume = 1.0f;

    //display settings
    public bool fullscreen = true;
    public bool vSync = true;

    //ui settings
    public int fontSizeMax = 11;
    public int default_fontSizeMax = 11;


}

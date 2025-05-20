using Godot;
using System;

public class PlayerData
{


    public string saveFileVersion = GlobalManager.gameVersion;

    public string playerName;
    public Godot.Collections.Dictionary<ushort, byte> cardInventory = new Godot.Collections.Dictionary<ushort, byte>();
    //<card id, number in collection (max is 5)>

    enum GAMETYPE { DIDDLE_CARDS, REAL_GAME }
    //game settings
    GAMETYPE gametype = GAMETYPE.DIDDLE_CARDS;
    public void init()
    {
        GainFullCollection();

        //playerName = "TEMPORARY";

    }


    public void GainFullCollection()
    {
        cardInventory.Clear();

        for (ushort i = 0; i < GlobalManager.CARD_COUNT; i++)
            cardInventory.Add(i, 5);


    }
}

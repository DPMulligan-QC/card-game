using Godot;
using System;

public class PlayerData
{


    public string saveFileVersion = GlobalManager.gameVersion;

    public string playerName;
    public Godot.Collections.Dictionary<ushort, byte> cardInventory = new Godot.Collections.Dictionary<ushort, byte>();
    //<card id, number in collection (max is 5)>
    public Godot.Collections.Dictionary<string, Godot.Collections.Dictionary<ushort, byte>> savedDecks;
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

    public bool AddNewDeck(Godot.Collections.Dictionary<ushort, byte> newDeck, string newDeckName)
    {
        if (savedDecks.ContainsKey(newDeckName))
        {
            return false;
        }
        savedDecks.Add(newDeckName, newDeck);
        return true;
    }
    public Godot.Collections.Dictionary<ushort, byte> GetDeck(string name)
    {
        return savedDecks[name];
    }
    public bool OverwriteDeck(string newDeckName, Godot.Collections.Dictionary<ushort, byte> newDeckContents)
    {
        if (savedDecks.ContainsKey(newDeckName))
        {
            savedDecks[newDeckName] = newDeckContents;
            return true;
        }

        return false;
    }
}

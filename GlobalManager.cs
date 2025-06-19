using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using static GlobalManager;
using static Godot.OpenXRHand;

[GlobalClass]
public partial class GlobalManager : Node
{
	// SAVE DATA STUFF ////////////////////////////////////////////////////////////////////

	public static string gameVersion = "v 0.0.001 Pre-Alpha (5/14/2025)";

	public static bool ignoreUserInput = false;

	public static PlayerData currentPlayerData = new PlayerData();
	public static PlayerData loadedPlayerData = new PlayerData();
	public static PlayerData loadedPlayerDataSlot2 = new PlayerData();
	public static PlayerData loadedPlayerDataSlot3 = new PlayerData();

	public static GameData gameData = new GameData();

	public enum SAVE_TYPE { PLAYER, GAME};

	public static string[] slotNames = new string[4];

	public static int currentSlot = 1;

	public override void _Ready()
	{

		//idToCardData = new System.Collections.Generic.Dictionary<ushort, CardData>();

		GD.Print("Gamemaster Ready");

		//Populate Dictionaries
		currentPlayerData.init();
		loadedPlayerData.init();
		loadedPlayerDataSlot2.init();
		loadedPlayerDataSlot3.init();


		//Load Game System Data
		LoadGameData();

		//Load saved Player Data into seperate fields so they can be displayed / manipulated on the save/load menu
		LoadPlayerData(1);
		LoadPlayerData(2);
		LoadPlayerData(3);

	

		//Set full screen
		//DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
	}
	public static void RefreshSlots()
	{
		Load(SAVE_TYPE.PLAYER, 1, true);
		Load(SAVE_TYPE.PLAYER, 2, true);
		Load(SAVE_TYPE.PLAYER, 3, true);
	}

	public static void DeleteSlot(int slotNum)
	{
		Delete(SAVE_TYPE.PLAYER, slotNum);
	}

	public static void SavePlayerData(int slotNum) { Save(SAVE_TYPE.PLAYER, slotNum); }
	public static void LoadPlayerData(int slotNum) { Load(SAVE_TYPE.PLAYER, slotNum, true);} //false
	public static void SaveGameData() { Save(SAVE_TYPE.GAME, 1); }
	public static void LoadGameData() { Load(SAVE_TYPE.GAME, 1); }
	public static void DeleteGameData() { Delete(SAVE_TYPE.GAME, 1); }


	private static void Save(SAVE_TYPE mySaveType, int slotNum)
	{
		GD.Print("SAVING...");
		//Don't save slot 0
		if (slotNum == 0) { return; }

		string myFilePath = "user://" + mySaveType.ToString() + slotNum + ".sav";

		//Save File Object
		using var saveGame = FileAccess.Open(myFilePath, FileAccess.ModeFlags.Write);

		string jsonString = string.Empty;

		//Convert entire class to json string.
		if (mySaveType == SAVE_TYPE.PLAYER)
		{
			jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(currentPlayerData);
		}
		if (mySaveType == SAVE_TYPE.GAME)
		{
			jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(gameData);
		}


		//Write String to File
		saveGame.StoreLine(jsonString);
	}
	public static void SaveToSlot(int slotNum)
	{
		Save(SAVE_TYPE.PLAYER, slotNum);
	}

	public static void SaveSettings()
	{
		Save(SAVE_TYPE.GAME, 1);
	}

	private static void Load(SAVE_TYPE mySaveType, int slotNum, bool loadToSlot = false)
	{
		string myFilePath = "user://" + mySaveType.ToString() + slotNum + ".sav";

		//Can't open file
		if (FileAccess.FileExists(myFilePath) == false)
		{
			GD.Print("File doesnt exist: " + myFilePath);
			initializeSlot(mySaveType, slotNum);
			return;
		}

		// Open File
		var saveGame = FileAccess.Open(myFilePath, FileAccess.ModeFlags.Read);

		//Read File Contents. File is only one line, so it does not need to be iterated.
		var jsonString = saveGame.GetLine();

		if (mySaveType == SAVE_TYPE.PLAYER)
		{
			if (loadToSlot == false)
			{
				Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, currentPlayerData);
			}
			else
			{
				if (slotNum == 1) { 
					Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, loadedPlayerData);
					slotNames[1] = loadedPlayerData.playerName;
					GD.Print("SLOT 1 LOADED, NAME =  " + slotNames[1]);
				}
				if (slotNum == 2) {
					Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, loadedPlayerDataSlot2);
					slotNames[2] = loadedPlayerDataSlot2.playerName;
					GD.Print("SLOT 2 LOADED, NAME =  " + slotNames[2]);
                }
				if (slotNum == 3) { 
					Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, loadedPlayerDataSlot3);
					slotNames[3] = loadedPlayerDataSlot3.playerName;
					GD.Print("SLOT 3 LOADED, NAME =  " + slotNames[3]);
                    
                }
			}
		}

		if (mySaveType == SAVE_TYPE.GAME)
		{
			Newtonsoft.Json.JsonConvert.PopulateObject(jsonString, gameData);
		}
	}


	private static void Delete(SAVE_TYPE mySaveType, int slotNum)
	{
		string myFilePath = "user://" + mySaveType.ToString() + slotNum + ".sav";

		//Overwrite Player Data for Specified Slot
		if (mySaveType == SAVE_TYPE.PLAYER)
		{
			initializeSlot(SAVE_TYPE.GAME, slotNum);
		}

		//Overwrite Default Game Data for Specified Slot
		//if (mySaveType == SAVE_TYPE.GAME) { initializeSlot(SAVE_TYPE.GAME, 1); }

		//Save to file
		Save(mySaveType, slotNum);
	}

	private static void initializeSlot(SAVE_TYPE mySaveType, int slotNum)
	{
		if (mySaveType == SAVE_TYPE.PLAYER)
		{
			if (slotNum == 0) { currentPlayerData = new PlayerData(); currentPlayerData.init(); }
			if (slotNum == 1) { loadedPlayerData = new PlayerData(); loadedPlayerData.init(); SavePlayerData(slotNum); }
			if (slotNum == 2) { loadedPlayerDataSlot2 = new PlayerData(); loadedPlayerDataSlot2.init(); SavePlayerData(slotNum); }
			if (slotNum == 3) { loadedPlayerDataSlot3 = new PlayerData(); loadedPlayerDataSlot3.init(); SavePlayerData(slotNum); }
		}
		if (mySaveType == SAVE_TYPE.GAME) { gameData = new GameData(); SaveGameData(); }
	}

	public static bool DoesSlotExist(int slotNum)
	{
		string myFilePath = "user://" + SAVE_TYPE.PLAYER.ToString() + slotNum + ".sav";

		return FileAccess.FileExists(myFilePath);
	}

	public static void SetSlotName(int slotNum, string newSlotName)
	{

		switch (slotNum){
			case 0:
				return;
			case 1:
				if (loadedPlayerData!=null)
					loadedPlayerData.playerName = newSlotName;
				currentPlayerData.playerName = newSlotName;
				return;
			case 2:
				if (loadedPlayerDataSlot2 != null)
					loadedPlayerDataSlot2.playerName = newSlotName;
				currentPlayerData.playerName = newSlotName;
				return;
			case 3:
				if (loadedPlayerDataSlot3 != null)
					loadedPlayerDataSlot3.playerName = newSlotName;
				currentPlayerData.playerName = newSlotName;
				return;
			default:
				return;
		}

	}

	public static void SetName(string newSlotName, int slotNum)
	{
		currentPlayerData.playerName = newSlotName;
		//slotNum = Math.Max(Math.Min(slotNum, 3), 1);  //slot must be between 1 and 3
		Save(SAVE_TYPE.PLAYER, slotNum);

		//LoadPlayerData(slotNum);  HANDLED BY PROFILE SCREEN
	}

	public static void LoadProfileToCurrent(int slotNum)
	{
		Load(SAVE_TYPE.PLAYER, slotNum);
        currentSlot = slotNum;
    }

	public static string GetName(int slotNum)
	{
		switch (slotNum)
		{
			case 0:
				return "INVALID SLOT NUM = 0";
			case 1:
				return loadedPlayerData.playerName;
			case 2:
				return loadedPlayerDataSlot2.playerName;
			case 3:
				return  loadedPlayerDataSlot3.playerName;

			default:
				return "INVALID SLOT NUM";
		}
	}


	//CARD LIBRARY INFORMATION ////////////////////////////////////////////////////////////////////


    public const int CARD_COUNT = 90;  //42->60->85->90
    public enum CARD_RARITY { RARITY_COMMON, RARITY_UNCOMMON, RARITY_RARE };
    public enum CARD_TYPE { UNIT_MAN, UNIT_MACHINE, TACTIC_FIELD, TACTIC_TRAP, TACTIC_INSTANT, ARMAMENT_VEHICLE, ARMAMENT_WEAPON };


	public struct CardData
	{
		public ushort id { get; set; }
		public string name { get; set; }
		public string description { get; set; }
		public string imagePath { get; set; }
		public byte cost { get; set; }
		public byte restrict { get; set; }
		public byte develop{ get; set; }
		public byte attack{ get; set; }
		public byte training{ get; set; }
		public byte health{ get; set; }
		public sbyte maintenance { get; set; }
		public CARD_TYPE type { get; set; }
		public CARD_RARITY rarity { get; set; }
		public bool specialOp { get; set; } 
		public bool reflex { get; set; }
		public bool invincible { get; set; }
		public bool immobile { get; set; }
		public bool evasive { get; set; }
		public bool unblockable { get; set; }
		public bool exposure { get; set; }
		public bool impulse { get; set; }
		public bool advancement { get; set; }
		public bool elimination { get; set; }
	};

	public int GetCardCount()
	{
		return CARD_COUNT;
	}

	public static Godot.Collections.Array<int> GetCurrentSlotCollection()
	{
		Godot.Collections.Array<int> output = new Godot.Collections.Array<int>();
		IEnumerable<KeyValuePair<ushort, byte>> inventory = currentPlayerData.cardInventory.ToArray();

		//world's most efficient indie dev algorithm...
		foreach (KeyValuePair<ushort, byte> pair in inventory) {

			for (byte i = 0; i < pair.Value; i++)
			{
				output.Add(pair.Key);
			}

		}
		return output;
	}

	public void GivePlayerFullCollection()
	{
		currentPlayerData.GainFullCollection();


	}

	public int SavedDeckCount()
	{
		return currentPlayerData.savedDecks.Count();
	}

	public Godot.Collections.Dictionary<ushort, byte> GetCardDict(string _name)
	{
		return currentPlayerData.savedDecks[_name];
	}

    public Godot.Collections.Dictionary<ushort, byte> GetCardDict(int index)
    {
		string[] keysToArray = currentPlayerData.savedDecks.Keys.ToArray<string>();
        return currentPlayerData.savedDecks[keysToArray[index]];
    }

	public string GetDeckNameFromIndex(int index)
	{
        return currentPlayerData.savedDecks.Keys.ToArray<string>()[index];
    }
	public bool HasDeck(string _name)
	{
		return currentPlayerData.savedDecks.ContainsKey(_name);

	}
	public bool AddNewDeck(Godot.Collections.Dictionary<ushort, byte>  cards, string name)
	{
		bool output = currentPlayerData.AddNewDeck(cards, name);
		SaveToSlot(currentSlot);

		return output;
	}

	public void DeleteDeck(string name)
	{
		if (currentPlayerData.savedDecks.ContainsKey(name)){
			currentPlayerData.savedDecks.Remove(name);
            SaveToSlot(currentSlot);

        }

    }


    //GAME INFO ////////////////////////////////////////////////////////////////////

    public enum ZONE { DECK, HAND, FRONT_LINE, STANDBY, GRAVEYARD};
}

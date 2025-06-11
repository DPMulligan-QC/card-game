using Godot;
using System;
using static GlobalManager;


public partial class CardBase : Node
{
    public ushort id { get; set; }
    public string name { get; set; }
    public string description { get; set; }
    public string imagePath { get; set; }
    public string cost { get; set; }
    public int restrict { get; set; }
    public byte develop { get; set; }
    public byte attack { get; set; }
    public byte training { get; set; }
    public byte health { get; set; }
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
    public bool isExposed { get; set; }
    public ZONE zone { get; set; }


    public virtual void Expose()
    {
        isExposed = true;
    }

    public virtual void Conceal()
    {
        isExposed = false;
    }

    public void PopulateData(int _id, string _name, string _description, string _cost, int _attack, int _training, int _health, int _type, int _restrict)
    {
        id = (ushort)_id;
        name = _name;
        description = _description;
        cost = (string)_cost;
        attack = (byte)_attack;
        training = (byte)_training;
        health = (byte)_health;
        type = (CARD_TYPE)_type;
        restrict = _restrict;
    }
    public void PopulateData(int _id, string _name, string _description, string _cost, int _attack, int _training, int _health, int _type)
    {
        id = (ushort)_id;
        name = _name;
        description = _description;
        cost = (string)_cost;
        attack = (byte)_attack;
        training = (byte)_training;
        health = (byte)_health;
        type = (CARD_TYPE)_type;
    }
    public void PopulateData(int _id, string _name, string _description, string _cost,int _type)
    {
        id = (ushort)_id;
        name = _name;
        description = _description;
        cost = (string)_cost;
        type = (CARD_TYPE)_type;
    }
    public void PopulateData(int _id, string _name, string _description, string _cost, int _type, int _restrict)
    {
        id = (ushort)_id;
        name = _name;
        description = _description;
        cost = (string)_cost;
        type = (CARD_TYPE)_type;
        restrict = _restrict;
    }

    public int GetCardType()
    {
        return (int)type;
    }

}

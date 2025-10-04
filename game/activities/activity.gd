class_name Activity extends RefCounted

#var name: String;
var statType: Stats.Types;
var statIncreases: Array[StatIncrease];

func _init(_statType: Stats.Types, _statIncreases: Array[StatIncrease]):
    statType = _statType;
    statIncreases = _statIncreases;

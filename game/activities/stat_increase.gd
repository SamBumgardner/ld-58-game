class_name StatIncrease extends RefCounted

var statType: Stats.Types;
var subTypeIndex: int;
var changeAmount: int;

# Initialize with empty values
func _init(_statType: Stats.Types, _subTypeIndex: int, _changeAmount: int):
    statType = _statType;
    subTypeIndex = _subTypeIndex;
    changeAmount = _changeAmount;

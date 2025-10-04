class_name StatIncrease extends Resource

@export
var statType: Stats.Types;
@export
var subTypeIndex: Stats.Substats;
@export
var changeAmount: int;

# Initialize with empty values
func _init(_statType: Stats.Types, _subTypeIndex: int, _changeAmount: int):
    statType = _statType;
    subTypeIndex = _subTypeIndex as Stats.Substats;
    changeAmount = _changeAmount;

class_name ConditionOverride extends Resource

enum Types {
    MOOD = 0,
    WEATHER = 1,
}

@export
var overrideType: Types;
@export
var overrideValue: int;
@export
var remainingDays: int;

# Initialize with empty values
func _init(_overrideType: Types = Types.MOOD, _overrideValue: int = 0, _remainingDays: int = 1):
    overrideType = _overrideType
    overrideValue = _overrideValue
    remainingDays = _remainingDays

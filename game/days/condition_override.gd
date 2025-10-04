class_name ConditionOverride extends RefCounted

enum Types {
    MOOD = 0,
    WEATHER = 1,
}

var overrideType: Types;
var overrideValue: int;
var remainingDays: int;

# Initialize with empty values
func _init(_overrideType: Types, _overrideValue: int, _remainingDays: int):
    overrideType = _overrideType
    overrideValue = _overrideValue
    remainingDays = _remainingDays

class_name EnhancementFactor extends Resource

enum EnhancementType {
    FLAT_ADD = 0,
    FLAT_MULTIPLY = 1,
}

static var enhancmentLookup: Dictionary = {
    EnhancementType.FLAT_ADD: flatAdd,
}

@export
var weatherConditional: Weather.Conditional;

@export
var moodConditional: Mood.Conditional;

@export
var affectedStatCategory: Stats.Types;

@export
var affectedSubstats: Array[Stats.Substats];

@export
var enhancementType: EnhancementType;
@export
var magnitude: float;

func _init(_weatherConditional: Weather.Conditional = Weather.Conditional.ANY,
        _moodConditional: Mood.Conditional = Mood.Conditional.ANY, _affectedStatCategory: Stats.Types = Stats.Types.STUDY,
        _affectedSubstats: Array[Stats.Substats] = [], _enhancementType: EnhancementType = EnhancementType.FLAT_ADD,
        _magnitude: float = 0):
    weatherConditional = _weatherConditional;
    moodConditional = _moodConditional;
    affectedStatCategory = _affectedStatCategory;
    affectedSubstats = _affectedSubstats;
    enhancementType = _enhancementType;
    magnitude = _magnitude;

func applyEnhancement(statIncreases: Array[StatIncrease], currentDay: Day, _player: Player) -> Array[StatIncrease]:
    # Check weather and mood conditions are met
    if (weatherConditional == Weather.Conditional.ANY or weatherConditional == currentDay.weather) \
            and (moodConditional == Mood.Conditional.ANY or moodConditional == currentDay.mood):
        # apply enhancement logic
        enhancmentLookup[enhancementType].call(self, statIncreases, currentDay, _player)

    return statIncreases;

# Used for sorting, since we want to apply addition, then multiplication
func get_priority() -> int:
    match enhancementType:
        EnhancementType.FLAT_ADD:
            return 0;
        EnhancementType.FLAT_MULTIPLY:
            return 1;
        _:
            push_error("could not determine priority while sorting enhancements");
            return 2;

static func flatAdd(caller: EnhancementFactor, statIncreases: Array[StatIncrease], _currentDay: Day, _player: Player) -> Array[StatIncrease]:
    for statIncrease: StatIncrease in statIncreases:
        if statIncrease.statType == caller.affectedStatCategory \
                and (caller.affectedSubstats.is_empty() or statIncrease.subTypeIndex in caller.affectedSubstats):
            statIncrease.changeAmount += caller.magnitude as int;

    return statIncreases;

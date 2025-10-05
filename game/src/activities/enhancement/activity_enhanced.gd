class_name ActivityEnhanced extends RefCounted

var baseActivity: Activity;

var enhancementFactors: Array[EnhancementFactor]
var enhancedIncreases: Array[StatIncrease];
var increaseDiff: Array[int]

func _init(_baseActivity: Activity, _enhancementFactors: Array[EnhancementFactor]):
    baseActivity = _baseActivity;
    enhancementFactors = _enhancementFactors;

func calculateEnhancedVersion(day: Day, player: Player) -> void:
    enhancementFactors.sort_custom(func(a, b): return a.get_priority() < b.get_priority());

    enhancedIncreases = baseActivity.statIncreases.duplicate_deep();
    for factor: EnhancementFactor in enhancementFactors:
        enhancedIncreases = factor.applyEnhancement(enhancedIncreases, day, player)
    
    increaseDiff = [];
    for i in enhancedIncreases.size():
        var diff = enhancedIncreases[i].changeAmount - baseActivity.statIncreases[i].changeAmount;
        increaseDiff.push_back(diff);

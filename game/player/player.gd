class_name Player extends RefCounted

var job: Job.Types
var stats: PlayerStats

func _init():
    job = Job.Types.HERO;
    stats = PlayerStats.new()
    
# get index of lowest stat
func getWeakestStatIndexForType(statType: Stats.Types) -> Stats.Substats:
    return stats.getWeakestMinorValueForType(statType) as Stats.Substats;

# get index of highest stat
func getStrongestStatIndexForType(statType: Stats.Types) -> Stats.Substats:
    return stats.getStrongestMinorValueForType(statType) as Stats.Substats;

func applyStatIncreases(statImprovements: Array[StatIncrease]) -> void:
    for statImprovement in statImprovements:
        stats.stats[statImprovement.statType][statImprovement.subTypeIndex] += statImprovement;
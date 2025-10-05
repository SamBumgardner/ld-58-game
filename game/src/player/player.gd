class_name Player extends Node

signal statsUpdated(stats: PlayerStats)

var job: Job.Types
var stats: PlayerStats

func initalize(_job: Job.Types = Job.Types.HERO, statsArray: Array[Array] = []):
    job = _job;
    stats = PlayerStats.new(statsArray);
    statsUpdated.emit(stats);
    
# get index of lowest stat
func getWeakestStatIndexForType(statType: Stats.Types) -> Stats.Substats:
    return stats.getWeakestMinorValueForType(statType) as Stats.Substats;

# get index of highest stat
func getStrongestStatIndexForType(statType: Stats.Types) -> Stats.Substats:
    return stats.getStrongestMinorValueForType(statType) as Stats.Substats;

func applyStatIncreases(statImprovements: Array[StatIncrease]) -> void:
    for statImprovement in statImprovements:
        stats.stats[statImprovement.statType][statImprovement.subTypeIndex] += statImprovement.changeAmount;
    statsUpdated.emit(stats);

func attemptBeatEventRequirements(eventOption: EventOption) -> EventRollRecord:
    var rollRecord = EventRollRecord.new();
    var success := true;
    var greatSuccess := true;
    
    rollRecord.majorStatRequirements = eventOption.majorStatRequirments;
    rollRecord.minorStatRequirements = eventOption.minorStatRequirements;
    
    for i in eventOption.majorStatRequirments.size():
        var initialTotal := stats.majorTotal(i);
        var bonus := rollD6(initialTotal / 10);
        rollRecord.majorStatInitialValues[i] = initialTotal;
        rollRecord.majorStatRollResults[i] = bonus;

        if (initialTotal + bonus) < eventOption.majorStatRequirments[i]:
            success = false;
            greatSuccess = false;
        elif (initialTotal + bonus) < eventOption.majorStatRequirments[i]:
            greatSuccess = false;
    
    for minorStatRequirement: StatIncrease in eventOption.minorStatRequirements:
        var initialTotal := stats.minorValue(minorStatRequirement.statType, minorStatRequirement.subTypeIndex);
        var bonus := rollD6(initialTotal / 10);
        rollRecord.minorStatInitialValues.push_back(initialTotal);
        rollRecord.minorStatRollResults.push_back(bonus);

        if (initialTotal + bonus) < minorStatRequirement.changeAmount:
            success = false;
            greatSuccess = false;
        elif (initialTotal + bonus) < minorStatRequirement.changeAmount * 2:
            greatSuccess = false;
            
    rollRecord.success = success;
    rollRecord.greatSuccess = greatSuccess
    return rollRecord

func rollD6(num_dice: int = 1) -> int:
    var sum = 0;
    for i in range(num_dice):
        sum += randi() % 6 + 1;
    return sum;

class EventRollRecord:
    var success: bool;
    var greatSuccess: bool;
    var majorStatRequirements: Array[int] = [0, 0, 0];
    var majorStatInitialValues: Array[int] = [0, 0, 0];
    var majorStatRollResults: Array[int] = [0, 0, 0];
    var minorStatRequirements: Array[StatIncrease]
    var minorStatInitialValues: Array[int] = [];
    var minorStatRollResults: Array[int] = [];

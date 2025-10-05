class_name PlayerStats extends RefCounted

var stats: Array[Array];

func majorTotal(statType: Stats.Types) -> int:
    var result = 0;
    result = stats[statType].reduce(func(accum, num): return accum + num);
    return result;

func minorValue(statType: Stats.Types, minorStatIndex: int) -> int:
    return stats[statType][minorStatIndex];

func getWeakestMinorValueForType(statType: Stats.Types) -> int:
    var substats = stats[statType]
    var minValue = 0;
    var weakestIndexes: Array[int] = [-1];
    for i in substats.size():
        if weakestIndexes[0] == -1 or substats[i] < minValue:
            minValue = substats[i];
            weakestIndexes = [i];
        elif substats[i] == minValue:
            weakestIndexes.push_back(i);
    
    return weakestIndexes.pick_random();

func getStrongestMinorValueForType(statType: Stats.Types) -> int:
    var substats = stats[statType]
    var maxValue = 0;
    var strongestIndexes: Array[int] = [-1];
    for i in substats.size():
        if strongestIndexes[0] == -1 or substats[i] > maxValue:
            maxValue = substats[i];
            strongestIndexes = [i];
        elif substats[i] == maxValue:
            strongestIndexes.push_back(i);
    
    return strongestIndexes.pick_random();

# Initialize with empty values
func _init(_stats: Array[Array] = []):
    stats = _stats;

    if stats.is_empty():
        stats = [];
        for majorStat in Stats.Types:
            var substats = [];
            for substat in Stats.MajorEnums:
                substats.push_back(0);
            stats.push_back([]);

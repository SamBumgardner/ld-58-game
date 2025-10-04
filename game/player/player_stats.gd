class_name PlayerStats extends RefCounted

var stats: Array[Array];

func major_total(statType: Stats.Types) -> int:
    var result = 0;
    stats[statType].reduce(func(accum, num): return accum + num, result);
    return result;

func minor_value(statType: Stats.Types, minorStatIndex: int) -> int:
    return stats[statType][minorStatIndex];

# Initialize with empty values
func _init():
    stats = [];
    for majorStat in Stats.Types:
        var substats = [];
        for substat in Stats.MajorEnums:
            substats.push_back(0);
        stats.push_back([]);

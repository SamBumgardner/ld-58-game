extends GridContainer

const SUBSTAT_TEMPLATE = "%s: %d"

@onready var substatDisplays: Array[Node] = [
    $Substat1,
    $Substat2,
    $Substat3,
    $Substat4,
    $Substat5,
    $Substat6,
    $Substat7,
    $Substat8,
    $Substat9,
]

func _onPlayerStatsUpdated(playerStats: PlayerStats) -> void:
    for i in substatDisplays.size():
        var statType: Stats.Types = (i / 3) as Stats.Types;
        var substatIndex: int = i % 3;
        #var statCategoryName = Stats.Types.find_key(statType);
        var substatValue: int = playerStats.stats[statType][substatIndex];
        var substatName: String = Stats.NamesLookup[statType][substatIndex];
        substatDisplays[i].text = SUBSTAT_TEMPLATE % [substatName, substatValue];

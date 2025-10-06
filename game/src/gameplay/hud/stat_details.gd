extends Control

const SUBSTAT_TEMPLATE = "%s: %d"

@onready var statGroups: Array[Node] = [
    $%StudyStats,
    $%PhysicalStats,
    $%CraftStats
]

func _onPlayerStatsUpdated(playerStats: PlayerStats) -> void:
    for statGroup: StatCategoryRequirements in statGroups:
        statGroup.setPlayerValues(playerStats)

class_name StatCategoryRequirements extends Control

@export var statCategory: Stats.Types;

@onready var majorStatIcon: TextureRect = $MajorStatIcon
@onready var majorStatThreshold: Label = $MajorStatIcon/MajorStatThreshold

@onready var minorStatIcons: Array[Node] = [
    $MinorStatIcon1,
    $MinorStatIcon2,
    $MinorStatIcon3,
]
@onready var minorStatLabels: Array[Node] = [
    $MinorStatIcon1/MinorStatThreshold,
    $MinorStatIcon2/MinorStatThreshold,
    $MinorStatIcon3/MinorStatThreshold,
]

func setValues(majorStatRequirements: Array[int], minorStatRequirements: Array[StatIncrease]):
    # todo: set major stat icon
    majorStatThreshold.text = "%d" % majorStatRequirements[statCategory];
    majorStatIcon.texture = load(Stats.PrimaryStatIconPaths[statCategory]);
    majorStatThreshold.show();
    var filteredMinorStatRequirements := minorStatRequirements.filter(func(x): return x.statType == statCategory);
    for i in minorStatLabels.size():
        if i < filteredMinorStatRequirements.size():
            var minorStatRequirement: StatIncrease = filteredMinorStatRequirements[i];

            minorStatIcons[i].show();
            minorStatIcons[i].texture = load(Stats.PathsLookup[minorStatRequirement.statType][minorStatRequirement.subTypeIndex]);
            var minorStatLabel: Label = minorStatLabels[i]
            minorStatLabel.text = "%d" % minorStatRequirement.changeAmount
        else:
            minorStatIcons[i].hide();

func displayChanges(statChanges: Array[StatIncrease], majorAlwaysVisible: bool = false):
    # todo: set major stat icon
    var filteredMinorStatChanges := statChanges.filter(func(x): return x.statType == statCategory);
    majorStatThreshold.hide();
    majorStatIcon.visible = not filteredMinorStatChanges.is_empty() or majorAlwaysVisible;
    majorStatIcon.texture = load(Stats.PrimaryStatIconPaths[statCategory]);
    
    for i in minorStatLabels.size():
        if i < filteredMinorStatChanges.size():
            var minorStatChange: StatIncrease = filteredMinorStatChanges[i];
            # todo: set minor stat icons
            minorStatIcons[i].show();
            minorStatIcons[i].texture = load(Stats.PathsLookup[minorStatChange.statType][minorStatChange.subTypeIndex]);
            var minorStatLabel: Label = minorStatLabels[i]
            minorStatLabel.text = "%+d" % filteredMinorStatChanges[i].changeAmount
        else:
            minorStatIcons[i].hide();

func setPlayerValues(playerStats: PlayerStats):
    majorStatThreshold.text = "%d" % playerStats.majorTotal(statCategory);
    majorStatIcon.texture = load(Stats.PrimaryStatIconPaths[statCategory]);
    majorStatThreshold.show();
    var minorStatValues = playerStats.stats[statCategory];
    for i in minorStatLabels.size():
        minorStatIcons[i].show();
        minorStatIcons[i].texture = load(Stats.PathsLookup[statCategory][i]);
        var minorStatLabel: Label = minorStatLabels[i]
        minorStatLabel.text = "%d" % minorStatValues[i]

class_name StatCategoryRequirements extends VBoxContainer

@export var statCategory: Stats.Types;

@onready var majorStatIcon: TextureRect = $MajorStatIcon
@onready var majorStatThreshold: Label = $MajorStatIcon/MajorStatThreshold

@onready var minorStatIcons: Array[Node] = [
    $MinorStatIcon1,
    $MinorStatIcon2,
    $MinorStatIcon3,
]
@onready var minorStatLabels: Array[Node] = [
    $MinorStatIcon1/MinorStatThreshold1,
    $MinorStatIcon2/MinorStatThreshold2,
    $MinorStatIcon3/MinorStatThreshold3,
]

func setValues(majorStatRequirements: Array[int], minorStatRequirements: Array[StatIncrease]):
    # todo: set major stat icon
    majorStatThreshold.text = "%d" % majorStatRequirements[statCategory];
    var filteredMinorStatRequirements := minorStatRequirements.filter(func(x): return x.statType == statCategory);
    for i in minorStatLabels.size():
        if i < filteredMinorStatRequirements.size():
            # todo: set minor stat icons
            minorStatIcons[i].show();

            var minorStatLabel: Label = minorStatLabels[i]
            minorStatLabel.text = "%d" % filteredMinorStatRequirements[i].changeAmount
        else:
            minorStatIcons[i].hide();

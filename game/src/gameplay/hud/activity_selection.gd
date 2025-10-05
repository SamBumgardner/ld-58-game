class_name ActivitySelection extends Control

signal activitySelected(activityIndex: int)

const HEADER_TEXT := "Training: %s"
const INCREASE_TEXT := "%s %+d"

@onready var title: Label = $%Title;
@onready var increases: Array = [
    $%Increase1,
    $%Increase2,
    $%Increase3,
    $%Increase4,
    $%Increase5,
]

@export
var activityIndex := 0;

func _ready():
    $TextureButton.pressed.connect(_onPressed);

    pivot_offset = size / 2;
    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2.ONE * 1.05, 2);
    tween.tween_property(self, "scale", Vector2.ONE, 2);
    tween.set_loops();

func _onActivitiesChanged(newActivities: Array[ActivityEnhanced]) -> void:
    var activity: ActivityEnhanced = newActivities.get(activityIndex);
    if activity != null:
        title.text = HEADER_TEXT % Stats.Types.find_key(activity.baseActivity.statType);
        
        for i in increases.size():
            if i < activity.enhancedIncreases.size():
                var statIncrease: StatIncrease = activity.enhancedIncreases[i];
                increases[i].text = INCREASE_TEXT % [
                    Stats.NamesLookup[statIncrease.statType][statIncrease.subTypeIndex],
                    statIncrease.changeAmount
                ];
                increases[i].show();
            else:
                increases[i].hide();

func _onPressed():
    activitySelected.emit(activityIndex);

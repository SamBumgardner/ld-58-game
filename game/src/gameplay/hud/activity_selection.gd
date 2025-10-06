class_name ActivitySelection extends Control

signal activitySelected(activityIndex: int)

@onready var majorStatIcon:MajorStatIcon = $%MajorStatIcon;
@onready var increases: Array[Node] = $%StatIncreases.get_children();

@export
var activityIndex := 0;

var scalingTween: Tween;

func _ready():
    $TextureButton.pressed.connect(_onPressed);
    $TextureButton.mouse_entered.connect(_onMouseEntered);
    $TextureButton.mouse_exited.connect(_onMouseExited);
    majorStatIcon.labelText ="";

    pivot_offset = size / 2;
    idleScalingLoop();
   

func idleScalingLoop():
    if scalingTween != null and scalingTween.is_valid():
        scalingTween.kill();
    scale = Vector2.ONE;
    scalingTween = create_tween();
    scalingTween.tween_property(self, "scale", Vector2.ONE * 1.05, 4);
    scalingTween.tween_property(self, "scale", Vector2.ONE, 4);
    scalingTween.set_loops();

func hoverScaleUp():
    if scalingTween != null and scalingTween.is_valid():
        scalingTween.kill();
    scalingTween = create_tween()
    scalingTween.tween_property(self, "scale", Vector2.ONE * 1.1, .1);

func _onActivitiesChanged(newActivities: Array[ActivityEnhanced]) -> void:
    var activity: ActivityEnhanced = newActivities.get(activityIndex);
    if activity != null:
        majorStatIcon.texture = load(Stats.PrimaryStatIconPaths[activity.baseActivity.statType]);
        
        for i in increases.size():
            if i < activity.enhancedIncreases.size():
                var statIncrease: StatIncrease = activity.enhancedIncreases[i];
                increases[i].texture = load(Stats.PathsLookup[statIncrease.statType][statIncrease.subTypeIndex]);
                increases[i].labelText = "%+d" % statIncrease.changeAmount;
                increases[i].show();
            else:
                increases[i].hide();

func _onPressed():
    activitySelected.emit(activityIndex);
    EventBus.globalActivitySelected.emit(activityIndex);

func _onMouseEntered():
    hoverScaleUp();

func _onMouseExited():
    idleScalingLoop();

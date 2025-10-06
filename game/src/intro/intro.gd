extends Control

const ENDINGS_ACHIEVED_TEMPLATE = "%d / %d Endings Achieved!"

@export var isStartingScene: bool = false;

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var splashImage: TextureRect = $%SplashImage;
@onready var endingsAchievedLabel: Label = $%EndingsAchievedCount;
@onready var restartButton: Button = $%RestartButton;

var receivedTransitionData: TransitionData;

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_DISABLED;
    # connect button click to restart game behavior
    restartButton.pressed.connect(_onRestartPressed);
    
    if self == get_tree().current_scene || isStartingScene:
        rootSceneActions();

func rootSceneActions() -> void:
    isStartingScene = true;
    receivedTransitionData = TransitionData.generateDefault();
    receivedTransitionData.endingData = TransitionData.EndingData.new();
    receivedTransitionData.endingData.achieved_ending = load("res://assets/data/endings/end_000_0_2_fireworks_maestro.tres");
    initScene(receivedTransitionData);
    startScene();


func initScene(transitionData: TransitionData):
    receivedTransitionData = transitionData;
    var ending = transitionData.endingData.achieved_ending;
    title.text = ending.title;
    description.text = ending.description;
    if ending.splashImage == null:
        splashImage.hide();
    
    var previousEndingCount = receivedTransitionData.metaProgressionData.completedEndings.values().filter(func(x): return x).size()
    receivedTransitionData.metaProgressionData.completedEndings[ending.resource_path] = 1
    var totalEndings: int = receivedTransitionData.metaProgressionData.completedEndings.size();
    var completedEndings: int = receivedTransitionData.metaProgressionData.completedEndings.values().filter(func(x): return x).size()
    
    # First-time completer
    if previousEndingCount != 1 and completedEndings == 1:
        $MetaContent/SkipDiaryNotice.show();
    
    endingsAchievedLabel.text = ENDINGS_ACHIEVED_TEMPLATE % [completedEndings, totalEndings]

func startScene():
    process_mode = Node.PROCESS_MODE_INHERIT;

func _onRestartPressed():
    print_debug("Starting to play again");
    var newTransitionData: TransitionData = TransitionData.generateDefault();
    newTransitionData.metaProgressionData = receivedTransitionData.metaProgressionData;
    newTransitionData.metaProgressionData.turboAvailable = true;

    var nextScene: PackedScene = load("res://src/gameplay/gameplay.tscn");
    var nextRoot: Node = nextScene.instantiate();
    add_sibling(nextRoot);
    nextRoot.initScene(newTransitionData);
    nextRoot.call_deferred("startScene");
    queue_free();
    return ;

extends Control

@export var isStartingScene: bool = false;

@onready var characterSelectors: Array[Node] = $%CharacterSelectors.get_children();
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var receivedTransitionData: TransitionData;
var characterScenarios: Array[TransitionData] = generateCharacterScenarios();

static func generateCharacterScenarios() -> Array[TransitionData]:
    var result: Array[TransitionData] = [
        # load resources here with character & initial characterScenarios data here.
        TransitionData.generateDefault(),
        TransitionData.generateDefault(),
        TransitionData.generateDefault(),
    ]
    var adrianData: TransitionData.PlayerData = TransitionData.PlayerData.new()
    adrianData.character_name = "Adrian the Alchemist"
    adrianData.characterPortrait = load("res://assets/art/heads/npc_head_15.png")
    adrianData.job = Job.Types.SCHOLAR
    adrianData.stats.assign([
        [2, 3, 2],
        [1, 1, 1],
        [1, 2, 2],
    ])
    var adrianStartingScenarios: Array[MajorEvent] = [
        load("res://assets/data/major_events/me_000_test.tres")
    ];
    
    var stellaData: TransitionData.PlayerData = TransitionData.PlayerData.new()
    stellaData.character_name = "Stella the Soldier"
    stellaData.characterPortrait = load("res://assets/art/heads/npc_head_29.png")
    stellaData.job = Job.Types.HERO
    stellaData.stats.assign([
        [1, 1, 2],
        [3, 2, 2],
        [1, 1, 1],
    ])
    var stellaStartingScenarios: Array[MajorEvent] = [
        load("res://assets/data/major_events/me_000_test.tres")
    ];
    
    
    var cainData: TransitionData.PlayerData = TransitionData.PlayerData.new()
    cainData.character_name = "Cain the Craftsman"
    cainData.characterPortrait = load("res://assets/art/heads/npc_head_12.png")
    cainData.job = Job.Types.TINKER
    cainData.stats.assign([
        [1, 2, 1],
        [2, 1, 1],
        [3, 3, 2],
    ])
    var cainStartingScenarios: Array[MajorEvent] = [
        load("res://assets/data/major_events/me_000_test.tres")
    ];
    
    result[0].playerData = adrianData;
    result[0].initialSetupData.possibleMajorEvents = adrianStartingScenarios;
    result[1].playerData = stellaData;
    result[1].initialSetupData.possibleMajorEvents = stellaStartingScenarios;
    result[2].playerData = cainData;
    result[2].initialSetupData.possibleMajorEvents = cainStartingScenarios;

    return result


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_DISABLED;
    # connect button click to restart game behavior

    for characterSelector: CharacterSelector in characterSelectors:
        characterSelector.characterSelected.connect(_onCharacterSelected);

    if self == get_tree().current_scene || isStartingScene:
        rootSceneActions();

func rootSceneActions() -> void:
    isStartingScene = true;
    receivedTransitionData = TransitionData.generateDefault();
    initScene(receivedTransitionData);
    startScene();


func initScene(transitionData: TransitionData):
    receivedTransitionData = transitionData;
    for characterSelector in characterSelectors:
        characterSelector.setValues(characterScenarios);

func startScene():
    process_mode = Node.PROCESS_MODE_INHERIT;

func _onCharacterSelected(characterIndex: int):
    print_debug("character selected");
    var newTransitionData: TransitionData = characterScenarios[characterIndex];
    newTransitionData.metaProgressionData = receivedTransitionData.metaProgressionData;

    var selectedJob: Job.Types = newTransitionData.playerData.job;
    EventBus.globalJobSelected.emit(selectedJob);

    var nextScene: PackedScene = load("res://src/gameplay/gameplay.tscn");
    var nextRoot: Node = nextScene.instantiate();
    add_sibling(nextRoot);
    nextRoot.initScene(newTransitionData);
    nextRoot.call_deferred("startScene");
    queue_free();

func _input(event: InputEvent):
    if (event is InputEventKey or event is InputEventMouseButton) and animationPlayer.is_playing():
        animationPlayer.advance(10);
        get_viewport().set_input_as_handled();

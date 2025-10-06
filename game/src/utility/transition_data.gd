class_name TransitionData extends Resource

@export var next_scene_name = "";
@export var playerData: PlayerData;
@export var metaProgressionData: MetaProgressionData;
@export var initialSetupData: InitialSetupData;
@export var scenarioData: ScenarioData;
@export var endingData: EndingData;

class PlayerData extends Resource:
    @export var job: Job.Types;
    @export var stats: Array[Array]
    @export var character_name: String;
    @export var characterPortrait: Texture2D;

class MetaProgressionData extends Resource:
    @export var tutorialComplete: bool = false
    @export var completedEndings: Dictionary = {}
    @export var turboAvailable: bool = false
    @export var turboMode: bool = false

class InitialSetupData extends Resource:
    @export var possibleMajorEvents: Array[MajorEvent]

class ScenarioData extends Resource:
    @export var currentDayData: CurrentDayData
    @export var nextMajorEvent: MajorEvent
    @export var daysTillMajorEvent: int
    @export var dayCount: int = 0
    
class CurrentDayData extends Resource:
    @export var originalWeather: Weather.Types;
    @export var originalForecast: Weather.Types;
    @export var originalMood: Mood.Types;
    @export var weather: Weather.Types;
    @export var forecast: Weather.Types;
    @export var mood: Mood.Types;
    @export var craftingCooldown: int;
    @export var moodOverride: ConditionOverride;
    @export var weatherOverride: ConditionOverride;

class EndingData extends Resource:
    @export var achieved_ending: Ending;

static func generateDefault() -> TransitionData:
    var default = TransitionData.new();
    default.playerData = PlayerData.new()
    default.playerData.character_name = "placeholder name"
    default.playerData.characterPortrait = load("res://icon.svg")
    default.playerData.job = Job.Types.HERO;
    default.playerData.stats.assign([
        [1, 1, 2],
        [3, 2, 2],
        [1, 1, 1],
    ]);
    
    default.initialSetupData = InitialSetupData.new()
    var majorEvent: MajorEvent = load("res://assets/data/major_events/me_000_test.tres")
    default.initialSetupData.possibleMajorEvents.assign([
        majorEvent
    ]);
    
    default.metaProgressionData = MetaProgressionData.new();
    default.metaProgressionData.completedEndings = buildTotalPossibleEndings();
    
    return default

static func buildTotalPossibleEndings() -> Dictionary:
    var result = {}
    var dir := DirAccess.open("res://assets/data/endings")
    const prefix = "res://assets/data/endings/"
    dir.list_dir_begin();
    for filename: String in dir.get_files():
        result[prefix + filename] = 0;
    return result;

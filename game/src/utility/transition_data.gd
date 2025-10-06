class_name TransitionData extends Resource

var next_scene_name = "";
var playerData: PlayerData;
var metaProgressionData: MetaProgressionData;
var initialSetupData: InitialSetupData;
var scenarioData: ScenarioData;
var endingData: EndingData;

class PlayerData extends Resource:
    var job: Job.Types;
    var stats: Array[Array]
    var character_name: String;
    var characterPortrait: Texture2D;

class MetaProgressionData extends Resource:
    var tutorialComplete: bool = false
    var completedEndings: Dictionary = {}
    var turboAvailable: bool = false
    var turboMode: bool = false

class InitialSetupData extends Resource:
    var possibleMajorEvents: Array[MajorEvent]

class ScenarioData extends Resource:
    var currentDayData: CurrentDayData
    var nextMajorEvent: MajorEvent
    var daysTillMajorEvent: int
    var dayCount: int = 0
    
class CurrentDayData extends Resource:
    var originalWeather: Weather.Types;
    var originalForecast: Weather.Types;
    var originalMood: Mood.Types;
    var weather: Weather.Types;
    var forecast: Weather.Types;
    var mood: Mood.Types;
    var craftingCooldown: int;
    var moodOverride: ConditionOverride;
    var weatherOverride: ConditionOverride;

class EndingData extends Resource:
    var achieved_ending: Ending;

static func generateDefault() -> TransitionData:
    var default = TransitionData.new();
    default.playerData = PlayerData.new()
    default.playerData.job = Job.Types.HERO;
    default.playerData.stats.assign([
        [1, 1, 2],
        [3, 2, 2],
        [1, 1, 1],
    ]);
    default.playerData.character_name = "Wilfred";
    
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

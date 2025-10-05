class_name TransitionData extends Resource

var next_scene_name = "";
var playerData: PlayerData;
var metaProgressionData: MetaProgressionData;
var initialSetupData: InitialSetupData;
var scenarioData: ScenarioData;

class PlayerData extends Resource:
    var job: Job.Types;
    var stats: Array[Array]

class MetaProgressionData extends Resource:
    var tutorialComplete: bool = false

class InitialSetupData extends Resource:
    var possibleMajorEvents = Array[MajorEvent]

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

static func generateDefault() -> TransitionData:
    var default = TransitionData.new();
    default.playerData = PlayerData.new()
    default.playerData.job = Job.Types.HERO;
    default.playerData.job = [
        [1, 1, 2],
        [3, 2, 2],
        [1, 1, 1],
    ]
    
    default.initialSetupData = InitialSetupData.new()
    var majorEvent: MajorEvent = MajorEvent.new();
    majorEvent.title = "test major event";
    majorEvent.description = "this is a test description";
    var eventOption: EventOption = EventOption.generateDefault();
    majorEvent.options = [eventOption];
    default.initialSetupData.possibleMajorEvents = [
        majorEvent
    ]
    
    return default
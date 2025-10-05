class_name Gameplay extends Node

signal dayCountChanged(newDayCount: int);
signal daysRemainingChanged(daysRemainingCount: int);
signal nextMajorEventChanged(newNextMajorEvent: MajorEvent);
signal activitiesChanged(newActivities: Array[Activity]);

#region node init
@onready var dayManager: DayManager = $DayManager;
@onready var moodTracker: Node = $MoodTracker
@onready var dayCountTracker: Node = $DayCountTracker
@onready var weatherDisplay: Node = $WeatherDisplay
@onready var majorObjectiveBanner: Node = $MajorObjectiveBanner
@onready var activitySelections: Array[Node] = [
    $ActivitySelection1,
    $ActivitySelection2,
    $ActivitySelection3,
]
#endregion


var player: Player;
var nextDayGenerator: NextDayGenerator;

var nextMajorEvent: MajorEvent:
    set(newValue):
        nextMajorEvent = newValue
        nextMajorEventChanged.emit(nextMajorEvent);
var daysTillMajorEvent: int:
    set(newValue):
        daysTillMajorEvent = newValue
        daysRemainingChanged.emit(daysTillMajorEvent);
var dayCount: int:
    set(newValue):
        dayCount = newValue
        dayCountChanged.emit(dayCount);
#var inventory: Inventory;

var activityOptions: Array[Activity] = [];
var enhancedActivities: Array[ActivityEnhanced] = [];
var lastCompletedActivity: Activity;

var receivedTransitionData: TransitionData;
@export
var isStartingScene: bool = false;


#region scene transition
func _ready():
    process_mode = Node.PROCESS_MODE_DISABLED

    dayManager.weatherChanged.connect(_onWeatherChanged);
    dayManager.moodChanged.connect(_onMoodChanged);
    
    # TODO: REMOVE LATER, TEMP SETUP
    dayManager.weatherChanged.connect(weatherDisplay._onWeatherChange);
    dayManager.forecastChanged.connect(weatherDisplay._onForecastChange);
    dayManager.moodChanged.connect(moodTracker._onMoodChange);
    dayCountChanged.connect(dayCountTracker._onDayCountChange);
    daysRemainingChanged.connect(majorObjectiveBanner._onDaysRemainingChange);
    nextMajorEventChanged.connect(majorObjectiveBanner._onMajorObjectiveChange);
    for i in activitySelections.size():
        var activitySelection: ActivitySelection = activitySelections[i] as ActivitySelection;
        activitySelection.activityIndex = i;
        activitiesChanged.connect(activitySelection._onActivitiesChanged);

    if self == get_tree().current_scene || isStartingScene:
        rootSceneActions();

func rootSceneActions():
    isStartingScene = true;
    receivedTransitionData = TransitionData.generateDefault();
    initScene(receivedTransitionData);
    startScene();

func initScene(transitionData: TransitionData):
    print_debug("initializing scene");
    # Determine if we're loading an existing scenario or if we're working on one in-progress
    var newStart: bool = transitionData.initialSetupData != null;
    
    # Initialize player with starting stats from transitionData
    player = Player.new(transitionData.playerData.job, transitionData.playerData.stats);

    if newStart:
        print_debug("determined that we're starting a fresh game");
        nextMajorEvent = transitionData.initialSetupData.possibleMajorEvents.pick_random()
        dayCount = 0
        daysTillMajorEvent = nextMajorEvent.setupDays;

        nextDayGenerator = NextDayGenerator.new(nextMajorEvent.weatherPool)
        var newDay = nextDayGenerator.getNewDayWithoutHistory();
        dayManager.applyNewDay(newDay);

    else:
        # currentDayData should be used to populate DayManager
        # should be able to use transition data to populate everything
        push_error("loading in-progress-scenarios is not implemented");
        
func startScene():
    print_debug("starting scene");
    process_mode = Node.ProcessMode.PROCESS_MODE_INHERIT
    _onSetUpNewDay() # may need to replace this with a timed animation thing

#endregion


#region day sequence management
func _onActivityConfirmed(selectedActivity: Activity) -> void:
    print_debug("activity confirmed");
    # Activate fade-out
    # Fade in training image
    # show results of training
    # expose button (or just click-anywhere) for user to continue.
    lastCompletedActivity = selectedActivity;
    _applyResultsOfActivity();
    
    #todo: remove this later
    _onSetUpNewDay();

func _applyResultsOfActivity() -> void:
    print_debug("applying results of activity");
    var enhancedActivityGains: Array[StatIncrease] = \
        enhancedActivities[activityOptions.find(lastCompletedActivity)].enhancedIncreases;
    player.applyStatIncreases(enhancedActivityGains);

func _onSetUpNewDay() -> void:
    print_debug("setting up new day");
    if dayCount != 0: # don't want to these steps if we're starting a fresh play
        var newDay = nextDayGenerator.getNextDay(dayManager.weather, dayManager.forecast, lastCompletedActivity);
        newDay = dayManager.applyNewDay(newDay);

    activityOptions = ActivityGenerator.generateActivities(dayManager.getCurrentDay(), player);
    activitiesChanged.emit(activityOptions);
    
    dayCount += 1;
    daysTillMajorEvent -= 1
    
    #todo: remove this later
    _onNewDayFadeIn();

func _onNewDayFadeIn() -> void:
    print_debug("new day is fading in");
    # this is where we check for events happening, bring up the exciting screen.
    pass ;

func _onEventCompleted() -> void:
    print_debug("event is completed");
    # Apply results of event
    # Clean up scene stuff
    # Resume normal gameplay
    pass ;

func _onMajorEventCompleted() -> void:
    print_debug("major event is completed");
    # check for game over exit
    # if not, apply status changes
    pass ;

#endregion

#region interruption_events
func _onWeatherChanged(_newWeather: Weather.Types) -> void:
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)

func _onMoodChanged(_newMood: Mood.Types) -> void:
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)

#endregion

# Needs to re-run when player changes or when day changes.
static func _createActivityEnhancements(baseActivites: Array[Activity], day: Day, p: Player) -> Array[ActivityEnhanced]:
    # Determine enhancement factors for the current day
    var weatherEnhancements = GameplayConsts.WEATHER_ENHANCEMENT_FACTORS[day.weather];
    var moodEnhancements = GameplayConsts.MOOD_ENHANCEMENT_FACTORS[day.mood];
    
    var totalEnhancements = []
    totalEnhancements.append_array(weatherEnhancements);
    totalEnhancements.append_array(moodEnhancements);

    # create enhanced activities that tie enhancement factors to each activity
    var result: Array[ActivityEnhanced] = [];
    for activity in baseActivites:
        var enhanced = ActivityEnhanced.new(activity, totalEnhancements);
        enhanced.calculateEnhancedVersion(day, p);
        result.append(enhanced);
    
    return result;

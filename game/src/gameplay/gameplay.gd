class_name Gameplay extends Node

signal dayCountChanged(newDayCount: int);
signal daysRemainingChanged(daysRemainingCount: int);
signal nextMajorEventChanged(newNextMajorEvent: MajorEvent);
signal activitiesChanged(newActivities: Array[ActivityEnhanced]);

#region node init
@onready var dayManager: DayManager = $DayManager;
@onready var moodTracker: Node = $MoodTracker;
@onready var dayCountTracker: Node = $DayCountTracker;
@onready var weatherDisplay: Node = $WeatherDisplay;
@onready var majorObjectiveBanner: Node = $MajorObjectiveBanner;
@onready var activitySelections: Array[Node] = [
    $ActivitySelection1,
    $ActivitySelection2,
    $ActivitySelection3,
];
@onready var statDetails: Node = $StatDetails;
@onready var player: Player = $Player;
@onready var majorEventDisplay: MajorEventDisplay = $MajorEventDisplay;
@onready var eventOutcomeDisplay: EventOutcomeDisplay = $EventOutcomeDisplay;
#endregion


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
var lastOutcome: MajorOutcome;

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
        activitySelection.activitySelected.connect(_onActivityConfirmed);
    player.statsUpdated.connect(statDetails._onPlayerStatsUpdated);
    majorEventDisplay.eventOptionSelected.connect(_onMajorEventCompleted);
    eventOutcomeDisplay.outcomeDisplayConfirmed.connect(_onEventOutcomeConfirmed);

    if self == get_tree().current_scene || isStartingScene:
        rootSceneActions();

func rootSceneActions():
    isStartingScene = true;
    receivedTransitionData = TransitionData.generateDefault();
    initScene(receivedTransitionData);
    startScene();

func initScene(transitionData: TransitionData):
    print_debug("initializing scene");
    receivedTransitionData = transitionData;
    # Determine if we're loading an existing scenario or if we're working on one in-progress
    var newStart: bool = transitionData.initialSetupData != null;
    
    # Initialize player with starting stats from transitionData
    player.initalize(transitionData.playerData.job, transitionData.playerData.stats);

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
func _onActivityConfirmed(activityIndex: int) -> void:
    var selectedActivity := activityOptions[activityIndex]
    print_debug("activity confirmed");
    # Activate fade-out
    # Fade in training image
    # show results of training
    # expose button (or just click-anywhere) for user to continue.
    lastCompletedActivity = selectedActivity;
    _applyResultsOfActivity(activityIndex);
    
    #todo: remove this later
    _onSetUpNewDay();

func _applyResultsOfActivity(activityIndex: int) -> void:
    print_debug("applying results of activity");
    var enhancedActivityGains: Array[StatIncrease] = \
        enhancedActivities[activityIndex].enhancedIncreases;
    player.applyStatIncreases(enhancedActivityGains);

func _onSetUpNewDay() -> void:
    print_debug("setting up new day");
    if dayCount != 0: # don't want to these steps if we're starting a fresh play
        var newDay = nextDayGenerator.getNextDay(dayManager.weather, dayManager.forecast, lastCompletedActivity);
        newDay = dayManager.applyNewDay(newDay);

    activityOptions = ActivityGenerator.generateActivities(dayManager.getCurrentDay(), player);
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)
    activitiesChanged.emit(enhancedActivities);
    
    dayCount += 1;
    daysTillMajorEvent -= 1
    
    #todo: remove this later
    _onNewDayFadeIn();

func _onNewDayFadeIn() -> void:
    print_debug("new day is fading in");
    # this is where we check for events happening, bring up the exciting screen.
    if daysTillMajorEvent == 0:
        process_mode = Node.PROCESS_MODE_DISABLED;
        majorEventDisplay.open(nextMajorEvent);

func _onEventCompleted(_selectionIndex: int) -> void:
    print_debug("event is completed");
    # Apply results of event

    # Clean up scene stuff
    # Resume normal gameplay
    process_mode = Node.PROCESS_MODE_INHERIT

func _onMajorEventCompleted(selectionIndex: int) -> void:
    print_debug("major event is completed");
    var selectedOption: EventOption = nextMajorEvent.options[selectionIndex];
    # todo: calculate outcome
    lastOutcome = [selectedOption.failureResult, selectedOption.successResult, selectedOption.greatSuccessResult].pick_random();

    #todo: figure out how to display outcome results
    eventOutcomeDisplay.open(lastOutcome);
    
    majorEventDisplay.close();
    # nextMajorEvent = selectedOption

func _onEventOutcomeConfirmed() -> void:
    # check for game over exit
    if lastOutcome.ending != null:
        print_debug("ending is happening, woo wooo!");
        receivedTransitionData.endingData = TransitionData.EndingData.new();
        receivedTransitionData.endingData.achieved_ending = lastOutcome.ending;

        var nextScene: PackedScene = load("res://src/ending/ending_display.tscn");
        var nextRoot: Node = nextScene.instantiate();
        add_sibling(nextRoot);
        nextRoot.initScene(receivedTransitionData);
        nextRoot.call_deferred("startScene");
        queue_free();
        return ;

    # apply results of lastOutcome:
    player.applyStatIncreases(lastOutcome.statChangesToApply);
    if lastOutcome.moodOverride != null:
        dayManager.applyOverride(lastOutcome.moodOverride);
    if lastOutcome.weatherOverride != null:
        dayManager.applyOverride(lastOutcome.weatherOverride);

    # set up next major event
    nextMajorEvent = lastOutcome.nextMajorObjective.pick_random();
    daysTillMajorEvent = nextMajorEvent.setupDays;
    
    eventOutcomeDisplay.close();
    process_mode = Node.PROCESS_MODE_INHERIT
    
    
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
    
    var totalEnhancements: Array[EnhancementFactor] = []
    totalEnhancements.append_array(weatherEnhancements);
    totalEnhancements.append_array(moodEnhancements);

    # create enhanced activities that tie enhancement factors to each activity
    var result: Array[ActivityEnhanced] = [];
    for activity in baseActivites:
        var enhanced = ActivityEnhanced.new(activity, totalEnhancements);
        enhanced.calculateEnhancedVersion(day, p);
        result.push_back(enhanced);
    
    return result;

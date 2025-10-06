class_name Gameplay extends Node

signal dayCountChanged(newDayCount: int);
signal daysRemainingChanged(daysRemainingCount: int);
signal nextMajorEventChanged(newNextMajorEvent: MajorEvent);
signal activitiesChanged(newActivities: Array[ActivityEnhanced]);

#region node init
@onready var centerContainerSettings: CenterContainer = $HudElements/Control/CenterContainerSettings;
@onready var dayManager: DayManager = $DayManager;
@onready var moodTracker: Node = $HudElements/Control/MoodTracker;
@onready var dayCountTracker: Node = $HudElements/Control/DayCountTracker;
@onready var weatherDisplay: Node = $HudElements/Control/WeatherDisplay;
@onready var majorObjectiveBanner: Node = $HudElements/Control/MajorObjectiveBanner;
@onready var activitySelections: Array[Node] = [
    $ActivitySelection1,
    $ActivitySelection2,
    $ActivitySelection3,
];
@onready var statDetails: Node = $HudElements/Control/StatDetails;
@onready var eventStatDetails: Node = $%EventStatDetails;
@onready var player: Player = $Player;
@onready var eventsLayer: CanvasLayer = $EventsLayer
@onready var majorEventDisplay: MajorEventDisplay = $%MajorEventDisplay;
@onready var eventOutcomeDisplay: EventOutcomeDisplay = $%EventOutcomeDisplay;
@onready var endDaySummary: EndDaySummary = $%EndDaySummary;
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
var selectedEnhancedActivity: ActivityEnhanced;
var selectedActivity: Activity;
var selectedActivityIndex: int;
var lastOutcome: MajorOutcome;

var receivedTransitionData: TransitionData;
@export var isStartingScene: bool = false;
# skip end of day journal entry, could have other speed-up effects too.
@export var turboMode: bool = false;


#region scene transition
func _ready():
    process_mode = Node.PROCESS_MODE_DISABLED
    centerContainerSettings.hide()

    dayManager.weatherChanged.connect(_onWeatherChanged);
    dayManager.moodChanged.connect(_onMoodChanged);
    
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
    player.statsUpdated.connect(eventStatDetails._onPlayerStatsUpdated);
    majorEventDisplay.eventOptionSelected.connect(_onMajorEventCompleted);
    eventOutcomeDisplay.outcomeDisplayConfirmed.connect(_onEventOutcomeConfirmed);
    endDaySummary.endOfDaySummaryClosed.connect($AnimationPlayer.play.bind("new_day_fade_in"));
    $TurboToggle.pressed.connect(_onTurboTogglePressed);

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
    player.initalize(transitionData.playerData.job, transitionData.playerData.stats,
        transitionData.playerData.character_name);

    # Allow turbo for players with meta progression
    if transitionData.metaProgressionData != null and transitionData.metaProgressionData.turboAvailable == true:
        $TurboToggle.show();
        turboMode = transitionData.metaProgressionData.turboMode;
        $TurboToggle.text = "Skip Diary: ON" if turboMode else "Skip Diary: OFF"

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
    selectedEnhancedActivity = enhancedActivities[activityIndex];
    selectedActivity = activityOptions[activityIndex];
    selectedActivityIndex = activityIndex;
    print_debug("activity confirmed");
    # starts fade-out, triggers next steps
    process_mode = Node.PROCESS_MODE_DISABLED;
    if not turboMode:
        $AnimationPlayer.play("end_of_day_fadeout");
    else:
        _applyResultsOfActivity();
    
func _applyResultsOfActivity() -> void:
    print_debug("applying results of activity");
    var enhancedActivityGains: Array[StatIncrease] = \
        enhancedActivities[selectedActivityIndex].enhancedIncreases;
    player.applyStatIncreases(enhancedActivityGains);

    _onSetUpNewDay();

func _onSetUpNewDay() -> void:
    print_debug("setting up new day");
    var previousWeather: Weather.Types = dayManager.weather;
    if dayCount != 0: # don't want to these steps if we're starting a fresh play
        var newDay = nextDayGenerator.getNextDay(dayManager.weather, dayManager.forecast, selectedActivity);
        newDay = dayManager.applyNewDay(newDay);
        endDaySummary.setValues(selectedActivity.statType, selectedEnhancedActivity.enhancedIncreases,
            previousWeather, dayManager.mood, daysTillMajorEvent, nextMajorEvent.title, player.characterName);

    activityOptions = ActivityGenerator.generateActivities(dayManager.getCurrentDay(), player);
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)
    activitiesChanged.emit(enhancedActivities);
    
    # load data onto endOfDay screen
        
    dayCount += 1;
    daysTillMajorEvent -= 1
    
    if daysTillMajorEvent == 0:
        process_mode = Node.PROCESS_MODE_DISABLED;
        
        eventsLayer.show();
        majorEventDisplay.open(nextMajorEvent);
    
    if dayCount == 1 or turboMode:
        _onNewDayFadeIn();

func _onNewDayFadeIn() -> void:
    print_debug("new day is fading in");

    # this is where we check for events happening, bring up the exciting screen.
    if daysTillMajorEvent == 0:
        process_mode = Node.PROCESS_MODE_DISABLED;
    else:
        process_mode = Node.PROCESS_MODE_INHERIT;

# NOTE: Not currently in use
func _onEventCompleted(_selectionIndex: int) -> void:
    print_debug("event is completed");
    # Apply results of event

    # Clean up scene stuff
    # Resume normal gameplay
    process_mode = Node.PROCESS_MODE_INHERIT

func _onMajorEventCompleted(selectionIndex: int) -> void:
    print_debug("major event is completed");
    var selectedOption: EventOption = nextMajorEvent.options[selectionIndex];
    
    # Calculating outcome (logic in Player class)
    var rollResults: Player.EventRollRecord = player.attemptBeatEventRequirements(selectedOption);
    if rollResults.greatSuccess:
        lastOutcome = selectedOption.greatSuccessResult;
    elif rollResults.success:
        lastOutcome = selectedOption.successResult;
    else:
        lastOutcome = selectedOption.failureResult;

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
    nextDayGenerator.overwriteWeatherPool(nextMajorEvent.weatherPool);
    
    eventOutcomeDisplay.close();
    eventsLayer.hide();
    process_mode = Node.PROCESS_MODE_INHERIT
    
    
#endregion
#region interruption_events
func _onWeatherChanged(_newWeather: Weather.Types) -> void:
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)

func _onMoodChanged(_newMood: Mood.Types) -> void:
    enhancedActivities = _createActivityEnhancements(activityOptions, dayManager.getCurrentDay(), player)

#endregion

func _onTurboTogglePressed():
    turboMode = not turboMode;
    $TurboToggle.text = "Skip Diary: ON" if turboMode else "Skip Diary: OFF"

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

#region settings menu methods
func _on_button_settings_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_settings_pressed():
    EventBus.globalUiElementSelected.emit()
    centerContainerSettings.show()

func _on_settings_menu_content_button_back_pressed():
    centerContainerSettings.hide()
#endregion

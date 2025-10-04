class_name Gameplay extends Node

@export
var dayConditions: DayConditions;
var currentDay: Day;

var player: Player;
var nextDayGenerator: NextDayGenerator;

var nextMajorEvent: MajorEvent;
var daysTillMajorEvent: int;
var dayCount: int;
#var inventory: Inventory;

var activityOptions: Array[Activity];
var enhancedActivities: Array[ActivityEnhanced]
var lastCompletedActivity: Activity;

func _init():
    dayConditions.weatherChanged.connect(_onWeatherChanged);
    dayConditions.moodChanged.connect(_onMoodChanged);
    
    # Need to sort out how the gameplay state first transitions in.
    # Should have some starting information

#region event_handling
func _onActivityConfirmed(selectedActivity: Activity) -> void:
    # Activate fade-out
    # Fade in training image
    # show results of training
    # expose button (or just click-anywhere) for user to continue.
    lastCompletedActivity = selectedActivity;
    
    #todo: remove this later
    _onNewDayBegin();

func _applyResultsOfActivity() -> void:
    # get enhancements
    # apply enhancements before applying stat increases
    var enhancedActivityGains: Array[StatIncrease] = \
        enhancedActivities[activityOptions.find(lastCompletedActivity)].enhancedIncreases;
    player.applyStatIncreases(enhancedActivityGains);

func _onNewDayBegin() -> void:
    var newDay = nextDayGenerator.getNextDay(dayConditions.weather, dayConditions.forecast, lastCompletedActivity);
    newDay = dayConditions.applyNewDay(newDay);
    currentDay = newDay;
    
    activityOptions = ActivityGenerator.generateActivities(currentDay, player);

func _onMajorEventCompleted() -> void:
    # check for game over exit
    # if not, apply status changes
    pass ;

func _onWeatherChanged(newWeather: Weather.Types) -> void:
    if newWeather != currentDay.weather:
        currentDay.weather = newWeather;
        enhancedActivities = _createActivityEnhancements(activityOptions, currentDay, player)

func _onMoodChanged(newMood: Mood.Types) -> void:
    if newMood != currentDay.mood:
        currentDay.mood = newMood;
        enhancedActivities = _createActivityEnhancements(activityOptions, currentDay, player)

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

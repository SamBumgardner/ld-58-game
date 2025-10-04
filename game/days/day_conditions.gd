class_name DayConditions extends Node

signal weatherChanged(newWeather: Weather.Types);
signal forecastChanged(newWeather: Weather.Types);
signal moodChanged(newMood: Mood.Types);

var originalWeather: Weather.Types;
var originalForecast: Weather.Types;
var originalMood: Mood.Types;

var weather: Weather.Types:
    set(newValue):
        var oldValue = weather;
        originalWeather = newValue;
        if weatherOverride != null:
            newValue = weatherOverride.overrideValue as Weather.Types;
        weather = newValue;
        if initialized && oldValue != weather:
            weatherChanged.emit(newValue);

var forecast: Weather.Types:
    set(newValue):
        var oldValue = weather;
        originalForecast = newValue;
        if weatherOverride != null and weatherOverride.remainingDays >= 1:
            newValue = weatherOverride.overrideValue as Weather.Types;
        forecast = newValue;
        if initialized && oldValue != weather:
            forecastChanged.emit(newValue);

var mood: Mood.Types:
    set(newValue):
        var oldValue = mood;
        originalMood = newValue;
        if moodOverride != null:
            newValue = moodOverride.overrideValue as Mood.Types;
        mood = newValue;
        if initialized && oldValue != mood:
            moodChanged.emit(newValue);

var craftingCooldown: int;
var moodOverride: ConditionOverride;
var weatherOverride: ConditionOverride;
var initialized = false;

# Initialize with empty values
func _init(_weather: Weather.Types, _mood: Mood.Types, _craftingCooldown: int,
        _moodOverride: ConditionOverride = null, _weatherOverride: ConditionOverride = null):
    weather = _weather
    mood = _mood
    craftingCooldown = _craftingCooldown
    moodOverride = _moodOverride
    weatherOverride = _weatherOverride
    initialized = true

static func initFromDay(day: Day) -> DayConditions:
    var newCondition = DayConditions.new(day.weather, day.mood, GameplayConsts.DEFAULT_CRAFTING_COOLDOWN);
    newCondition.weather = day.weather;
    newCondition.mood = day.mood;

    return newCondition;
      
func applyNewDay(day: Day) -> void:
    for override in [moodOverride, weatherOverride]:
        if override.remainingDays == 0:
            match override.Types:
                ConditionOverride.Types.MOOD:
                    moodOverride = null;
                ConditionOverride.Types.WEATHER:
                    weatherOverride = null
        else:
            override.remainingDays -= 1;

    weather = day.weather;
    forecast = day.forecast;
    mood = day.mood;
    
    return Day.new(weather, forecast, mood);

func forceRemoveOverride(overrideType: ConditionOverride.Types) -> void:
    match overrideType:
        ConditionOverride.Types.MOOD:
            moodOverride = null;
            mood = Mood.Types.RELAXED;
        ConditionOverride.Types.WEATHER:
            weatherOverride = null
            weather = originalWeather;
            forecast = originalForecast;

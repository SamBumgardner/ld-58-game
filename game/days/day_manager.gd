class_name DayManager extends Node

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


func initialize(initData: TransitionData.CurrentDayData):
    originalWeather = initData.originalWeather
    originalForecast = initData.originalForecast
    originalMood = initData.originalMood
    weather = initData.weather
    forecast = initData.forecast
    mood = initData.mood
    craftingCooldown = initData.craftingCooldown
    moodOverride = initData.moodOverride
    weatherOverride = initData.weatherOverride

    initialized = true

      
func applyNewDay(day: Day) -> Day:
    for override in [moodOverride, weatherOverride]:
        if override != null and override.remainingDays == 0:
            match override.Types:
                ConditionOverride.Types.MOOD:
                    moodOverride = null;
                ConditionOverride.Types.WEATHER:
                    weatherOverride = null
        elif override != null:
            override.remainingDays -= 1;

    weather = day.weather;
    forecast = day.forecast;
    mood = day.mood;
    
    return Day.new(weather, forecast, mood);

func applyOverride(newOverride: ConditionOverride) -> void:
    match newOverride.overrideType:
        ConditionOverride.Types.MOOD:
            moodOverride = newOverride.duplicate();
        ConditionOverride.Types.WEATHER:
            weatherOverride = newOverride.duplicate();

func forceRemoveOverride(overrideType: ConditionOverride.Types) -> void:
    match overrideType:
        ConditionOverride.Types.MOOD:
            moodOverride = null;
            mood = Mood.Types.RELAXED;
        ConditionOverride.Types.WEATHER:
            weatherOverride = null
            weather = originalWeather;
            forecast = originalForecast;
            
func getCurrentDay() -> Day:
    return Day.new(weather, forecast, mood);

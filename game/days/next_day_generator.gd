class_name NextDayGenerator extends RefCounted

var weatherPool: Array[Weather.Types];
# var eventPool: Array; # Stretch goal to implement minor events.

func _init(_weatherPool: Array[Weather.Types] = []):
    weatherPool = _weatherPool;

func overwriteWeatherPool(weatherTypes: Array[Weather.Types]) -> void:
    weatherPool = weatherTypes.duplicate();

func addToWeatherPool(additionalWeatherTypes: Array[Weather.Types]) -> void:
    weatherPool.append_array(additionalWeatherTypes);

func getNewDayWithoutHistory() -> Day:
    weatherPool.shuffle();
    var newWeather: Weather.Types = \
        weatherPool.pop_back() if weatherPool.size() > 0 else Weather.Types.FAIR;
    var newForecast: Weather.Types = \
        weatherPool.pop_back() if weatherPool.size() > 0 else Weather.Types.FAIR;
    var newMood = Mood.Types.RELAXED;
    
    return Day.new(newWeather, newForecast, newMood);
    

func getNextDay(currentWeather: Weather.Types, currentForecast: Weather.Types,
        activityPerformed: Activity) -> Day:
    var newMood: Mood.Types = \
        GameplayConsts.ACTIVITY_WEATHER_NEXT_MOOD_LOOKUP[activityPerformed.statType][currentWeather];

    weatherPool.shuffle();
    var newForecast: Weather.Types = \
        weatherPool.pop_back() if weatherPool.size() > 0 else Weather.Types.FAIR;

    return Day.new(currentForecast, newForecast, newMood);
extends Control

@onready
var weatherDisplayLabel: Label = $CurrentWeatherText;
@onready
var forecastDisplayLabel: Label = $ForecastWeatherText;

func _onWeatherChange(newWeather: Weather.Types) -> void:
    weatherDisplayLabel.text = "Current Weather: %s" % Weather.Types.find_key(newWeather);
    $CurrentWeather.texture = load(Weather.WeatherIconPaths[newWeather]);

func _onForecastChange(newForecast: Weather.Types) -> void:
    forecastDisplayLabel.text = "Tomorrow's Weather: %s" % Weather.Types.find_key(newForecast);
    $ForecastWeather.texture = load(Weather.WeatherIconPaths[newForecast]);

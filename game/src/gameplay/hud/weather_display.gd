extends Control

@onready
var weatherDisplayLabel: Label = $CurrentWeather;
@onready
var forecastDisplayLabel: Label = $ForecastWeather;

func _onWeatherChange(newWeather: Weather.Types) -> void:
    weatherDisplayLabel.text = "Current Weather: %s" % Weather.Types.find_key(newWeather);

func _onForecastChange(newForecast: Weather.Types) -> void:
    forecastDisplayLabel.text = "Tomorrow's Weather: %s" % Weather.Types.find_key(newForecast);

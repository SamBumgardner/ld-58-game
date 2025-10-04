class_name Day extends RefCounted

var weather: Weather.Types;
var forecast: Weather.Types;
var mood: Mood.Types;

# Initialize with empty values
func Day(_weather: Weather.Types, _forecast: Weather.Types, _mood: Mood.Types):
    weather = _weather;
    mood = _mood;
    forecast = _forecast;

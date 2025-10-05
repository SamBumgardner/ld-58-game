class_name MajorEvent extends Resource

@export_category("Preparation Parameters")
@export
var setupDays: int = 10;
@export
var weatherPool: Array[Weather.Types] = [
    Weather.Types.FAIR,
    Weather.Types.FAIR,
    Weather.Types.FAIR,
    Weather.Types.HOT,
    Weather.Types.HOT,
    Weather.Types.CLOUDY,
    Weather.Types.CLOUDY,
    Weather.Types.RAINY,
    Weather.Types.RAINY,
    Weather.Types.MISTY,
]

@export_category("EventContents")
@export
var title: String;
@export_multiline
var description: String;
#var cutscene: DialogueCutscene;
@export
var options: Array[EventOption]

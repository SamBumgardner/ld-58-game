extends Control

#region node init
@export
var audioBusNameToEdit: StringName = "Master";

@onready var displayPercentValue: Label = $%PercentValue;
@onready var hSliderVolume: HSlider = $%HSliderVolume;
@onready var labelAudioBusName: Label = $%LabelAudioBusName;

var audioBusIndex: int = 0;
const displayPercentageMultiplier = 100
#endregion

func _ready() -> void:
    labelAudioBusName.text = audioBusNameToEdit
    audioBusIndex = AudioServer.get_bus_index(audioBusNameToEdit)

    if audioBusIndex == -1:
        print_debug("Audio bus not found of name:", audioBusNameToEdit)
        return

    hSliderVolume.value = (
        db_to_linear(AudioServer.get_bus_volume_db(audioBusIndex))
        * displayPercentageMultiplier
    )

func _buildVolumePercentage(value: int) -> String:
    return str(value)

func _on_h_slider_volume_value_changed(updated_value):
    var updated_volume_db = linear_to_db(updated_value / displayPercentageMultiplier)
    AudioServer.set_bus_volume_db(audioBusIndex, updated_volume_db)
    displayPercentValue.text = _buildVolumePercentage(updated_value)

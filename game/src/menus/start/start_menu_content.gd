extends Control

#region node init
@onready var buttonQuit: Button = $%ButtonQuit;
#endregion

func _ready() -> void:
    if OS.get_name() == "Web":
        buttonQuit.visible = false

#region button mouse entered
func _on_button_credits_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_play_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_quit_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_settings_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()
#endregion

#region button pressed
func _on_button_credits_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().change_scene_to_file("res://src/menus/credits/credits_menu.tscn")

func _on_button_play_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().change_scene_to_file("res://src/gameplay/gameplay.tscn")

func _on_button_quit_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().quit()

func _on_button_settings_pressed():
    EventBus.globalUiElementSelected.emit()
    pass
#endregion

#region menu bar mouse entered
func _on_menu_bar_choose_character_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()
#endregion

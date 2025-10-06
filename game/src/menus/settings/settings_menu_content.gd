extends Control

func _on_button_back_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_back_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().change_scene_to_file("res://src/menus/start/start_menu.tscn")

extends Control

func _on_settings_menu_content_button_back_pressed():
    get_tree().change_scene_to_file("res://src/menus/start/start_menu.tscn")

extends Control

#region node init
@onready var buttonQuit: Button = $%ButtonQuit;
#endregion

var savedMetaProgression: TransitionData.MetaProgressionData;

func _ready() -> void:
    if OS.get_name() == "Web":
        buttonQuit.visible = false
    
    # load meta progression data - CURRENTLY BROKEN
    # if ResourceLoader.exists("user://metadata.res"):
    #     var stuff = ResourceLoader.load("user://metadata.res")
    #     if stuff is TransitionData.MetaProgressionData:
    #         savedMetaProgression = stuff;

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

    var newTransitionData: TransitionData = TransitionData.generateDefault();
    #var newTransitionData.metaProgressionData # if we have time, load meta progression data here.
    if savedMetaProgression != null:
        newTransitionData.metaProgressionData = savedMetaProgression

    var nextScene: PackedScene = load("res://src/intro/intro.tscn");
    var nextRoot: Node = nextScene.instantiate();
    get_tree().root.add_child(nextRoot);
    nextRoot.initScene(newTransitionData);
    nextRoot.call_deferred("startScene");
    queue_free();

func _on_button_quit_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().quit()

func _on_button_settings_pressed():
    EventBus.globalUiElementSelected.emit()
    get_tree().change_scene_to_file("res://src/menus/settings/settings_menu.tscn")
#endregion

#region menu bar mouse entered
func _on_menu_bar_choose_character_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()
#endregion

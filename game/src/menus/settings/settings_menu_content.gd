extends Control

signal buttonBackPressed();

func _on_button_back_mouse_entered():
    EventBus.globalUiElementMouseEntered.emit()

func _on_button_back_pressed():
    EventBus.globalUiElementSelected.emit()
    buttonBackPressed.emit()

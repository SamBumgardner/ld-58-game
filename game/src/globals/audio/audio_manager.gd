extends Node

@onready var sfxUiClickConfirm = $SFXUIClickConfirm

func _ready() -> void:
    EventBus.globalActivitySelected.connect(playSfxUiClickConfirm)
    pass

func playSfxUiClickConfirm(_unused: int) -> void:
    sfxUiClickConfirm.play()

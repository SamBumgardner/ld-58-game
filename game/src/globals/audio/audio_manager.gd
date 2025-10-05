extends Node

@onready var sfxUiClickConfirm = $SFXUIClickConfirm
@onready var sfxTrainingStudyingComplete = $TrainingComplete/SFXTrainingTypeStudyComplete

func _ready() -> void:
    EventBus.globalActivitySelected.connect(_playSfxTrainingComplete)
    pass

func _playSfxUiClickConfirm(_unused: int) -> void:
    sfxUiClickConfirm.play()

func _playSfxTrainingComplete(_unused: int) -> void:
    if _unused == 0:
        _playSfxTrainingTypeStudyComplete()
    elif _unused == 1:
        _playSfxTrainingTypePhysicalComplete()
    elif _unused == 2:
        _playSfxTrainingTypeCraftComplete()
    else:
        print_debug("Warning: Tried to play SFX out of bounds at", _unused)

func _playSfxTrainingTypeStudyComplete() -> void:
    sfxTrainingStudyingComplete.play()

func _playSfxTrainingTypePhysicalComplete() -> void:
    sfxTrainingStudyingComplete.play()

func _playSfxTrainingTypeCraftComplete() -> void:
    sfxTrainingStudyingComplete.play()

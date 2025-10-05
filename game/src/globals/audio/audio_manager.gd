extends Node

@onready var sfxTrainingTypeCraftComplete = $TrainingComplete/SFXTrainingTypeCraftComplete
@onready var sfxTrainingTypePhysicalComplete = $TrainingComplete/SFXTrainingTypePhysicalComplete
@onready var sfxTrainingTypeStudyComplete = $TrainingComplete/SFXTrainingTypeStudyComplete
@onready var sfxUiClickConfirm = $SFXUIClickConfirm

func _ready() -> void:
    EventBus.globalActivitySelected.connect(_playSfxTrainingComplete)

func _playSfxUiClickConfirm(_unused: int) -> void:
    sfxUiClickConfirm.play()

#region training complete

func _playSfxTrainingComplete(_unused: int) -> void:
    if _unused == 0:
        _playSfxTrainingTypeStudyComplete()
    elif _unused == 1:
        _playSfxTrainingTypePhysicalComplete()
    elif _unused == 2:
        _playSfxTrainingTypeCraftComplete()
    else:
        print_debug("Warning: Tried to play SFX out of bounds at", _unused)

func _playSfxTrainingTypeCraftComplete() -> void:
    _stopSfxTrainingComplete()
    sfxTrainingTypeCraftComplete.play()

func _playSfxTrainingTypePhysicalComplete() -> void:
    _stopSfxTrainingComplete()
    sfxTrainingTypePhysicalComplete.play()

func _playSfxTrainingTypeStudyComplete() -> void:
    _stopSfxTrainingComplete()
    sfxTrainingTypeStudyComplete.play()

func _stopSfxTrainingComplete() -> void:
    sfxTrainingTypeCraftComplete.stop()
    sfxTrainingTypePhysicalComplete.stop()
    sfxTrainingTypeStudyComplete.stop()

#endregion

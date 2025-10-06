extends Node

@onready var sfxTrainingTypeCraftComplete = $TrainingComplete/SFXTrainingTypeCraftComplete
@onready var sfxTrainingTypePhysicalComplete = $TrainingComplete/SFXTrainingTypePhysicalComplete
@onready var sfxTrainingTypeStudyComplete = $TrainingComplete/SFXTrainingTypeStudyComplete
@onready var sfxUiClickConfirm = $SFXUIClickConfirm
@onready var sfxUiMouseEntered = $SFXUIMouseEntered

var playerSelectedJobType = Job.Types.TINKER;

func _ready() -> void:
    EventBus.globalActivitySelected.connect(_playSfxTrainingComplete)
    EventBus.globalJobSelected.connect(_setVoice)
    EventBus.globalUiElementMouseEntered.connect(_playSfxUiMouseEntered)
    EventBus.globalUiElementSelected.connect(_playSfxUiClickConfirm)

func _playSfxUiClickConfirm() -> void:
    sfxUiClickConfirm.play()

func _playSfxUiMouseEntered() -> void:
    sfxUiMouseEntered.play()

#region training complete

func _playSfxTrainingComplete(activityIndex: int) -> void:
    if activityIndex == 0:
        _playSfxTrainingTypeStudyComplete()
    elif activityIndex == 1:
        _playSfxTrainingTypePhysicalComplete()
    elif activityIndex == 2:
        _playSfxTrainingTypeCraftComplete()
    else:
        print_debug("Warning: Tried to play SFX out of bounds at", activityIndex)

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

func _setVoice(jobType: Job.Types) -> void:
    if jobType == Job.Types.HERO:
        pass
    elif jobType == Job.Types.SCHOLAR:
        pass
    elif jobType == Job.Types.TINKER:
        pass
    else:
        print_debug("Warning: Tried to set voice for unexpected job type", jobType)

#endregion

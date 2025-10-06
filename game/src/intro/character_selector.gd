class_name CharacterSelector extends Control

signal characterSelected(characterIndex: int)

@export var characterIndex: int = 0;

@onready var characterNameLabel: Label = $%Name
@onready var portraitTexture: TextureRect = $%Portrait

func _ready() -> void:
    $%Button.pressed.connect(characterSelected.emit.bind(characterIndex))

func setValues(possibleCharacters: Array[TransitionData]):
    var playerData = possibleCharacters[characterIndex].playerData;
    characterNameLabel.text = playerData.character_name;
    portraitTexture.texture = playerData.characterPortrait;

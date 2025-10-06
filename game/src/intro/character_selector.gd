class_name HeroSelector extends Control

signal characterSelected(characterIndex: int)

@export var characterIndex: int = 0;

@onready var characterNameLabel: Label = $%Name
@onready var portraitTexture: TextureRect = $%Portrait

func _ready() -> void:
    $%Button.pressed.connect(characterSelected.emit.bind(characterIndex))

func setValues(possibleCharacters: Array[TransitionData.PlayerData]):
    var playerData = possibleCharacters[characterIndex]
    characterNameLabel.text = playerData.character_name;
    portraitTexture.texture = playerData.characterPortrait;

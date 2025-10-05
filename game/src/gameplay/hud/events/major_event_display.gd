class_name MajorEventDisplay extends Control

signal eventOptionSelected(selectedIndex: int);

@export var testMajorEvent: MajorEvent;

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var eventOptionDisplays: Array[Node] = $%EventOptions.get_children();

func _init() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS;

func _ready() -> void:
    for display: EventOptionDisplay in eventOptionDisplays:
        display.eventOptionSelected.connect(eventOptionSelected.emit);
    
    if testMajorEvent != null and self == get_tree().current_scene:
        open(testMajorEvent);

func open(majorEvent: MajorEvent) -> void:
    title.text = majorEvent.title;
    description.text = majorEvent.description;
    for eventOptionDisplay: EventOptionDisplay in eventOptionDisplays:
        eventOptionDisplay.setValues(majorEvent.options);
    show();

func close() -> void:
    hide();

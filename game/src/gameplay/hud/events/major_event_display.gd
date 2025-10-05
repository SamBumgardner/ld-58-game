class_name MajorEventDisplay extends Control

signal eventOptionSelected(selectedIndex: int);

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var eventOptionDisplays: Array[Node] = $%EventOptions.get_children();

func _ready() -> void:
    for display: EventOptionDisplay in eventOptionDisplays:
        display.eventOptionSelected.connect(eventOptionSelected.emit);

func open(majorEvent: MajorEvent) -> void:
    title.text = majorEvent.title;
    description.text = majorEvent.description;
    for eventOptionDisplay: EventOptionDisplay in eventOptionDisplays:
        eventOptionDisplay.setValues(majorEvent.options);
    show();

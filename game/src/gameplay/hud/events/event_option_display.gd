class_name EventOptionDisplay extends PanelContainer

signal eventOptionSelected(selectedIndex: int);

@export var eventOptionIndex: int = -1;

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var statCategoryRequirements: Array[Node] = $%StatRequirements.get_children();
@onready var attemptButton: Button = $%AttemptButton

func _ready() -> void:
    attemptButton.pressed.connect(_onAttemptButtonPressed);

func setValues(eventOptions: Array[EventOption]) -> void:
    if eventOptionIndex == -1:
        push_error("eventOptionDisplay is missing export var setup: see eventOptionSelected");

    if eventOptionIndex < eventOptions.size():
        var eventOption = eventOptions[eventOptionIndex];
        title.text = eventOption.title;
        description.text = eventOption.description;
        for statCategoryRequirement: StatCategoryRequirements in statCategoryRequirements:
            statCategoryRequirement.setValues(
                eventOption.majorStatRequirments,
                eventOption.minorStatRequirements
            );
        show();
    else:
        hide();

func _onAttemptButtonPressed() -> void:
    eventOptionSelected.emit(eventOptionIndex);

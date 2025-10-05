class_name EventOutcomeDisplay extends Control

signal outcomeDisplayConfirmed();

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var statCategoryRequirements: Array[Node] = $%StatRequirements.get_children();
@onready var confirmButton: Button = $%ConfirmButton
@onready var resultsContainer: Control = $%ResultsContainer

@export var testOutcome: MajorOutcome;

func _init() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS;

func _ready() -> void:
    confirmButton.pressed.connect(outcomeDisplayConfirmed.emit);
    
    if testOutcome != null and self == get_tree().current_scene:
        open(testOutcome);

func open(majorOutcome: MajorOutcome) -> void:
    title.text = majorOutcome.title;
    description.text = majorOutcome.description;
    
    var hasStatChanges: bool = majorOutcome.statChangesToApply != null and not majorOutcome.statChangesToApply.is_empty();
    resultsContainer.visible = hasStatChanges;
    
    if hasStatChanges:
        for statCategoryRequirement: StatCategoryRequirements in statCategoryRequirements:
            statCategoryRequirement.displayChanges(majorOutcome.statChangesToApply);
    
    confirmButton.text = "Continue" if majorOutcome.ending == null else "Conclude";
    show();

func close() -> void:
    hide();

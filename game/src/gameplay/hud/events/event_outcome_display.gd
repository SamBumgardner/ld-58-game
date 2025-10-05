extends Control

signal outcomeDisplayConfirmed(selectedIndex: int);

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var statCategoryRequirements: Array[Node] = $%StatRequirements.get_children();
@onready var confirmButton: Button = $%ConfirmButton
@onready var resultsHeader: Label = $%ResultsHeader
@onready var resultsContainer: Label = $%ResultsContainer

func _ready() -> void:
    confirmButton.pressed.connect(_onAttemptButtonPressed);

func setValues(majorOutcome: MajorOutcome) -> void:
    title.text = majorOutcome.title;
    description.text = majorOutcome.description;
    
    var hasStatChanges: bool = majorOutcome.statChangesToApply != null and not majorOutcome.statChangesToApply.is_empty();
    resultsHeader.visible = hasStatChanges;
    resultsContainer.visible = hasStatChanges;
    
    if hasStatChanges:
        for statCategoryRequirement: StatCategoryRequirements in statCategoryRequirements:
            statCategoryRequirement.displayChanges(majorOutcome.statChangesToApply);
    
    confirmButton.text = "Continue" if majorOutcome.ending == null else "Conclude";

func _onAttemptButtonPressed() -> void:
    outcomeDisplayConfirmed.emit();

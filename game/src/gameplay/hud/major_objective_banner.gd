extends RichTextLabel

const standardDisplayString = "Next Event:\n[font_size=24]\"%s\"[/font_size]\nin %d days";
var displayObjectiveName: String = "";
var displayDaysRemaining: int = 0;

func _onMajorObjectiveChange(newObjective: MajorEvent) -> void:
    displayObjectiveName = newObjective.title if newObjective != null else "null event";
    text = standardDisplayString % [displayObjectiveName, displayDaysRemaining]

func _onDaysRemainingChange(daysRemaining: int) -> void:
    displayDaysRemaining = daysRemaining;
    text = standardDisplayString % [displayObjectiveName, displayDaysRemaining]

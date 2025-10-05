extends Label

const standardDisplayString = "Next Objective: %s\nin %d days";
var displayObjectiveName: String = "";
var displayDaysRemaining: int = 0;

func _onMajorObjectiveChange(newObjective: MajorEvent) -> void:
    displayObjectiveName = newObjective.title;
    text = standardDisplayString % [displayObjectiveName, displayDaysRemaining]

func _onDaysRemainingChange(daysRemaining: int) -> void:
    displayDaysRemaining = daysRemaining;
    text = standardDisplayString % [displayObjectiveName, displayDaysRemaining]

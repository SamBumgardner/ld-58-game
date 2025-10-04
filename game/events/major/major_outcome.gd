class_name MajorOutcome extends Resource

#var cutscene: DialogueCutscene;
@export_category("Immediate Effects")
@export
var statChangesToApply: Array[StatIncrease];
@export
var moodOverride: ConditionOverride;
@export
var weatherOverride: ConditionOverride;

@export_category("Next Objective")
@export
var nextMajorObjective: MajorEvent;
@export
var daysUntilNextEvent: int;

@export_category("Game End")
var ending: Ending;
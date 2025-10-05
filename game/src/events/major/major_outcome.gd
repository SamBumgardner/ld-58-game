class_name MajorOutcome extends Resource

#var cutscene: DialogueCutscene;
@export_category("Outcome Description")
@export var title: String = "Default title";
@export_multiline var description: String = "Default Description";

@export_category("Immediate Effects")
@export var statChangesToApply: Array[StatIncrease] = [];
@export var moodOverride: ConditionOverride;
@export var weatherOverride: ConditionOverride;

@export_category("Next Objective")
@export var nextMajorObjective: Array[MajorEvent] = [];
@export var daysUntilNextEvent: int = 10;

@export_category("Game End")
@export var ending: Ending;

static func generateDefaultVictory() -> MajorOutcome:
    var default = MajorOutcome.new();
    default.ending = Ending.new()
    default.ending.win = true;
    return default;

static func generateDefaultGameOver() -> MajorOutcome:
    var default = MajorOutcome.new();
    default.ending = Ending.new()
    default.ending.win = false;
    return default;
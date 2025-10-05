class_name EventOption extends Resource

@export
var title: String = "option test title";
@export_multiline
var description: String = "option test description";
#var selectionCutscene: DialogueCutscene;
@export_category("Stats")
@export
var majorStatRequirments: Array[int] = [0, 0, 0];
@export
var minorStatRequirements: Array[StatIncrease] = []; # it's a little hacky to reuse StatIncrease here, but it'll be fine.
@export_category("Results")
@export
var failureResult: MajorOutcome;
@export
var successResult: MajorOutcome;
@export
var greatSuccessResult: MajorOutcome;

static func generateDefault() -> EventOption:
    var default = EventOption.new();
    default.failureResult = MajorOutcome.generateDefaultGameOver();
    default.successResult = MajorOutcome.generateDefaultVictory();
    default.greatSuccessResult = default.successResult;

    return default;

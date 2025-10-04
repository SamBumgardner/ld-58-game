class_name EventOption extends Resource

@export
var title: String;
@export
var description: String;
#var selectionCutscene: DialogueCutscene;
@export_category("Stats")
@export
var majorStatRequirments: Array[int] = [0, 0, 0];
@export
var minorStatRequirements: Array[StatIncrease]; # it's a little hacky to reuse StatIncrease here, but it'll be fine.
@export_category("Results")
@export
var failureResult: MajorOutcome;
@export
var successResult: MajorOutcome;
@export
var greatSuccessResult: MajorOutcome;

class_name EventOutcomeDisplay extends Control

signal outcomeDisplayConfirmed();

@onready var title: Label = $%Title;
@onready var description: Label = $%Description;
@onready var statCategoryRequirements: Array[Node] = $%StatRequirements.get_children();
@onready var confirmButton: Button = $%ConfirmButton
@onready var resultsContainer: Control = $%ResultsContainer
@onready var moodAndWeatherContainer: Control = $%OptionalMoodAndWeatherInfo
@onready var moodTexture: TextureRect = $%MoodTexture
@onready var moodLabel: Label = $%MoodDaysLabel
@onready var weatherTexture: TextureRect = $%WeatherTexture
@onready var weatherLabel: Label = $%WeatherDaysLabel

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
            statCategoryRequirement.displayChanges(majorOutcome.statChangesToApply, true);
    
    var hasWeatherOverride := majorOutcome.weatherOverride != null;
    var hasMoodOverride := majorOutcome.moodOverride != null;
    moodAndWeatherContainer.visible = hasWeatherOverride or hasMoodOverride;

    weatherLabel.visible = hasWeatherOverride;
    weatherTexture.visible = hasWeatherOverride;
    if hasWeatherOverride:
        var dayCount = majorOutcome.weatherOverride.remainingDays;
        weatherLabel.text = "%d Days" % dayCount if dayCount > 1 else "%d Day" % dayCount;
        weatherTexture.texture = load(Weather.WeatherIconPaths[majorOutcome.weatherOverride.overrideValue]);

    moodLabel.visible = hasMoodOverride;
    moodTexture.visible = hasMoodOverride;
    if hasMoodOverride:
        var dayCount = majorOutcome.moodOverride.remainingDays;
        moodLabel.text = "%d Days" % dayCount if dayCount > 1 else "%d Day" % dayCount;
        moodTexture.texture = load(Mood.MoodIconPaths[majorOutcome.moodOverride.overrideValue]);
    
    confirmButton.text = "Continue" if majorOutcome.ending == null else "Conclude";
    show();

func close() -> void:
    hide();

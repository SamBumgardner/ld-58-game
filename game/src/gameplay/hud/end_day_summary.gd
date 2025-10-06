class_name EndDaySummary extends Control

signal endOfDaySummaryClosed();

# Activity Stat 
const PREAMBLE = "Dear Diary,
I %s [img=48]%s[/img] today.

Here's how it went:"

# Activity Stat, Weather, New Mood, DaysRemaining, NextEventTitle, CharacterName
const CONCLUSION = "[center][img=48]%s[/img] on a [img=48]%s[/img] day left me feeling [img=36]%s[/img][/center]

%s 
[indent][font_size=18]\"%s\"[/font_size][/indent]
%s"

const DAYS_LEFT = "I have %d days left until"
const ONE_DAY_LEFT = "Just 1 day left until"
const NO_TIME_LEFT = "It's time for"

const READY_SOON = "I hope I'll be ready."
const READY_NOW = "I hope I'm ready."

@onready var preamble: RichTextLabel = $%Preamble;
@onready var conclusion: RichTextLabel = $%Conclusion;
@onready var statChangeDisplays: Array[Node] = $%StatChanges.get_children();
@onready var closeButton: Button = $MarginContainer/VBoxContainer/Button

func _ready():
    closeButton.pressed.connect(endOfDaySummaryClosed.emit);

func setValues(trainedStat: Stats.Types, statChanges: Array[StatIncrease],
        currentWeather: Weather.Types, nextMood: Mood.Types, daysRemaining: int,
        nextEventTitle: String, _playerName: String) -> void:
    var verb: String = "worked on";
    match trainedStat:
        Stats.Types.STUDY:
            verb = "studied"
        Stats.Types.PHYSICAL:
            verb = "worked on"
        Stats.Types.CRAFT:
            verb = "practiced"
    preamble.text = PREAMBLE % [verb, Stats.PrimaryStatIconPaths[trainedStat]];
    var timeLeftPhrase: String = DAYS_LEFT % (daysRemaining - 1) if daysRemaining > 2 else ONE_DAY_LEFT if daysRemaining == 2 else NO_TIME_LEFT;
    var readinessPhrase: String = READY_SOON if daysRemaining > 1 else READY_NOW;
    conclusion.text = CONCLUSION % [
        Stats.PrimaryStatIconPaths[trainedStat],
        Weather.WeatherIconPaths[currentWeather],
        Mood.MoodIconPaths[nextMood],
        timeLeftPhrase,
        nextEventTitle,
        readinessPhrase
    ]

    for statCategoryRequirement: StatCategoryRequirements in statChangeDisplays:
        statCategoryRequirement.displayChanges(statChanges, true);

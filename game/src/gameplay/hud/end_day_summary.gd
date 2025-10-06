class_name EndDaySummary extends Control

signal endOfDaySummaryClosed();

# Activity Stat 
const PREAMBLE = "Dear Diary,
I worked on [img=48]%s[/img] today.

Here's how it went:"

# Activity Stat, Weather, New Mood, DaysRemaining, NextEventTitle, CharacterName
const CONCLUSION = "[center][img=48]%s[/img] on a [img=48]%s[/img] day left me feeling [img=36]%s[/img][/center]

I have %d days left until 
[indent][font_size=18]\"%s\"[/font_size][/indent]
I hope I'll be ready."

@onready var preamble: RichTextLabel = $%Preamble;
@onready var conclusion: RichTextLabel = $%Conclusion;
@onready var statChangeDisplays: Array[Node] = $%StatChanges.get_children();
@onready var closeButton: Button = $MarginContainer/VBoxContainer/Button

func _ready():
    closeButton.pressed.connect(endOfDaySummaryClosed.emit);

func setValues(trainedStat: Stats.Types, statChanges: Array[StatIncrease],
        currentWeather: Weather.Types, nextMood: Mood.Types, daysRemaining: int,
        nextEventTitle: String, playerName: String) -> void:
    preamble.text = PREAMBLE % Stats.PrimaryStatIconPaths[trainedStat];
    conclusion.text = CONCLUSION % [
        Stats.PrimaryStatIconPaths[trainedStat],
        Weather.WeatherIconPaths[currentWeather],
        Mood.MoodIconPaths[nextMood],
        daysRemaining,
        nextEventTitle
    ]

    for statCategoryRequirement: StatCategoryRequirements in statChangeDisplays:
        statCategoryRequirement.displayChanges(statChanges, true);

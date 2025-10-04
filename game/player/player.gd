class_name Player

var job: Job.Types
var stats: PlayerStats

func Player():
    job = Job.Types.HERO;
    stats = PlayerStats.new()
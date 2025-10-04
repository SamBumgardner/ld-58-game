class_name Player extends RefCounted

var job: Job.Types
var stats: PlayerStats

func Player():
    job = Job.Types.HERO;
    stats = PlayerStats.new()
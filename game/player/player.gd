class_name Player extends RefCounted

var job: Job.Types
var stats: PlayerStats

func _init():
    job = Job.Types.HERO;
    stats = PlayerStats.new()
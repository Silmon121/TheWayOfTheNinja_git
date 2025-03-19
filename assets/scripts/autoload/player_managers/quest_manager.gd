class_name QuestTemplate extends Node2D

signal allow_next_level()

@export var quest_name: String
var quest_description: String
var quest_progress_counter: int = 1
var active_task: String

signal update_quest(quest_name, quest_description)


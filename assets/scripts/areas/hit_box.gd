class_name HitBox extends Area2D

@export_group("Define hitbox")
@export var deal_damage: bool = true
@export var entity: CharacterBody2D
@export var damage: int

func _ready():
	#This will activate for other entities that are made by EntityTemplate
	#This makes it more dynamic
	if entity != null and entity is Entity:
		damage = entity.damage

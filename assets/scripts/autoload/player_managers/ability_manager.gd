extends Node

var falling: bool = false

var fireball_ready: bool = true
var kunai_ready: bool = true
var shuriken_ready: bool = true

signal fireball_casted
signal shuriken_thrown
signal kunai_thrown
signal jumped

func restore_abilities():
	fireball_ready = true
	kunai_ready = true
	shuriken_ready = true

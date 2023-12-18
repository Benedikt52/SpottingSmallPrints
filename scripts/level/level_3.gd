extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fog.update_pos(player.position)

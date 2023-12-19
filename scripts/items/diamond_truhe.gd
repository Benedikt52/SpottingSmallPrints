
extends StaticBody2D

#Speichert die ID des Schluessel der gedropped wird
var schlüssel_id = 0

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var collisionshape = $CollisionShape2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var is_closed = true




func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.animation =  "closed"

func _on_interact():
	var resource = load("res://dialogs/note_dialog.dialogue")
	if is_closed:
		if PlayerVariables.lightsout_is_finnished:
			Inventory.collect_item(Inventory.Item_Type.DIAMOND, schlüssel_id)
			#Hier muss noch der Dialog abgespielt werden
			is_closed = false
			# Interaktion mit Truhe deaktivieren
			detecion_area.disabled = true
			# Textur der offenen Truhe laden 
			sprite.animation =  "open"
			DialogManager.show_dialogue_balloon(resource,"Diamantene_Kiste")
			print("is finnished")
		else:
			DialogManager.show_dialogue_balloon(resource,"Diamantene_Kiste_negative")
			print("is not finnished")
			
		
		
		

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal editDialogDone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ConfirmationDialog_confirmed():
	emit_signal("editDialogDone")
	pass # Replace with function body.

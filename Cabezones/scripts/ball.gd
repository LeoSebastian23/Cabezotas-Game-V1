extends RigidBody2D

# Opcional: definir grupo kickable para que KickArea lo detecte
@export var kickable_group: String = "kickable"

func _ready():
	# Asegurarse de estar en el grupo
	if not is_in_group(kickable_group):
		add_to_group(kickable_group)

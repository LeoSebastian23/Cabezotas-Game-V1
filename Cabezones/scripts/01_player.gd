extends CharacterBody2D
# Indica que este script extiende la clase CharacterBody2D, usada para personajes controlables por el jugador.

@export var speed = 300
# Velocidad de movimiento horizontal del jugador.

@export var jump_force = -400.0
# Fuerza del salto del jugador. Negativo porque en Godot el eje Y crece hacia abajo.

@export var gravity = 1200.0
# Aceleración de la gravedad que se aplica al jugador cuando está en el aire.

@export var kick_force = 800.0
# Fuerza que se aplica al balón al patear.

@export var push_force = 200.0  # fuerza más baja para empujar caminando
# Fuerza más baja que se aplica al balón si el jugador solo lo toca caminando sin patear.

@onready var anim = $AnimatedSprite2D
# Referencia al nodo AnimatedSprite2D del jugador para controlar animaciones.

@onready var kick_area = $KickArea
# Referencia al área de colisión (Area2D) usada para detectar cuando el balón está cerca del jugador.

var can_jump = true
# Bandera que indica si el jugador puede saltar (está en el suelo).

var screen_size: Vector2
# Guarda el tamaño de la ventana para limitar el movimiento del jugador dentro de la pantalla.

var kick_active = false
# Bandera que indica si el jugador está realizando un pateo activo.

func _ready():
	screen_size = get_viewport_rect().size
	# Guarda el tamaño de la pantalla al iniciar el juego.
	kick_area.monitoring = false  # desactivada por defecto
	# Desactiva el área de pateo al inicio para que no detecte colisiones antes de patear.

func _physics_process(delta):
	# Función que se ejecuta cada frame de física.

	# Aplicar gravedad
	if not is_on_floor():
				velocity.y += gravity * delta
		# Si no está en el suelo, aplica gravedad al eje Y.
	else:
		can_jump = true
		# Si está en el suelo, permite que el jugador pueda saltar nuevamente.

	# Movimiento horizontal
	var horizontal_input = 0
	if Input.is_action_pressed("move_right"):
		horizontal_input = 1
		# Detecta input de mover a la derecha
	if Input.is_action_pressed("move_left"):
		horizontal_input = -1
		# Detecta input de mover a la izquierda
	velocity.x = horizontal_input * speed
	# Aplica la velocidad horizontal al jugador.

	# Salto
	if Input.is_action_just_pressed("move_up") and can_jump:
		velocity.y = jump_force
		can_jump = false
		# Si el jugador presiona saltar y puede, aplica fuerza de salto y bloquea hasta tocar suelo.

	# Detectar input para patear
	if Input.is_action_just_pressed("kick"):
		anim.play("kick")
		# Reproduce la animación de pateo.
		kick_area.monitoring = true
		# Activa el área de pateo para detectar colisiones con el balón.
		kick_active = true  # indicar que se pateó

	# Mover el personaje
	move_and_slide()
	# Aplica la física de movimiento con deslizamiento.

	# Mantener dentro de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)
	# Limita la posición del jugador dentro de los bordes de la pantalla.

# Señal del KickArea
func _on_KickArea_body_entered(body):
	# Se ejecuta cuando un cuerpo entra en el área de pateo.
	print("bodyEntered")
	if body is RigidBody2D and body.is_in_group("ball"):
		# Solo aplica si el cuerpo es un RigidBody2D y pertenece al grupo "ball"
		var direction: Vector2 = (body.global_position - global_position).normalized()
		# Calcula la dirección desde el jugador hacia el balón y la normaliza.

		if kick_active:
			# Si el jugador está realizando un pateo activo:
			body.apply_impulse(Vector2.ZERO, direction * kick_force)
			# Aplica una fuerza fuerte en la dirección del balón.
			kick_active = false
			kick_area.monitoring = false  # desactivar área tras patear
			# Desactiva el área de pateo hasta el próximo golpe.
		else:
			# Si solo choca caminando:
			body.apply_impulse(Vector2.ZERO, direction * push_force)
			# Aplica una fuerza más baja para empujar suavemente el balón.







	


	
	

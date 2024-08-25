extends CanvasLayer

@onready var lock_pick = $lock_pick
@onready var som_lockPick = $AudioStreamPlayer2D
@onready var button_certo = $controles/certo
@onready var label_feedBack = $feedback/Label
@onready var timer = $feedback/Timer
@onready var value_sens = $controles/value_sens
@onready var passou_efeito = $passou_efeito
@onready var cadeado = $cadeado

@onready var tranca = $area_destrancar/trancas/tranca
@onready var tranca_2 = $area_destrancar/trancas/tranca2
@onready var tranca_3 = $area_destrancar/trancas/tranca3
@onready var tranca_4 = $area_destrancar/trancas/tranca4
@onready var tranca_5 = $area_destrancar/trancas/tranca5
@onready var tranca_6 = $area_destrancar/trancas/tranca6
@onready var tranca_7 = $area_destrancar/trancas/tranca7

@export_category("configuração cadeado")
@export var sensibilidade: int
@export var quantidade_de_travas: int = 1

var acertos: int

var rng = RandomNumberGenerator.new()
var index_area: int 

var area_certa
var area_colidindo

var position_ini_feedback: Vector2

func _ready():
	
	
	label_feedBack.visible = false
	position_ini_feedback = label_feedBack.global_position
	
	index_area = rng.randi_range(0, 6)
	
	if index_area == 0:
		area_certa = tranca
	
	if index_area == 1:
		area_certa = tranca_2
	
	if index_area == 2:
		area_certa = tranca_3
	
	if index_area == 3:
		area_certa = tranca_4
	
	if index_area == 4:
		area_certa =tranca_5
	
	if index_area == 5:
		area_certa = tranca_6
	
	if index_area == 6:
		area_certa = tranca_7
	
	print("cadeado: area certa: " + str(area_certa))

func _process(delta):
	
	if label_feedBack.visible:
		label_feedBack.position.y -= 1
		
	
	sensibilidade = value_sens.value
	
	lock_pick.move_and_slide()


func _feedBack(acertou: bool):
	label_feedBack.global_position = position_ini_feedback
	
	label_feedBack.visible = true
	timer.start()
	
	if acertou:
		label_feedBack.text = "SUPINPAAAA ACERTOU!!!"
		label_feedBack.add_theme_color_override("font_outline_color", "00f600")
		
		lock_pick.rotation_degrees += 10
		await get_tree().create_timer(0.4).timeout
		lock_pick.rotation_degrees -= 10
		
	
	else:
		label_feedBack.text = "QUE PENA, ERROU!!!"
		label_feedBack.add_theme_color_override("font_outline_color", "ff3000")
		lock_pick.rotation_degrees += 1
		await get_tree().create_timer(0.2).timeout
		lock_pick.rotation_degrees -= 1


func _on_up_pressed():
	lock_pick.velocity.y -= sensibilidade

func _on_down_pressed():
	lock_pick.velocity.y += sensibilidade

func _on_certo_pressed():
	button_certo.scale = Vector2(4.0, 4.0)
	
	if area_certa == area_colidindo and !som_lockPick.playing:
		som_lockPick.play()
		
		acertos += 1
		if _quantidade_de_acertos() == quantidade_de_travas:
			print("quantidade que o player teve que acertar: " + str(_quantidade_de_acertos()))
			print("quantidade que o player teve que acertar: " + str(quantidade_de_travas))
			cadeado.region_rect = Rect2(Vector2(36,4), Vector2(24,28))
		
		_feedBack(true)
	if area_certa != area_colidindo:
		_feedBack(false)
	
	await get_tree().create_timer(0.2).timeout
	button_certo.scale = Vector2(4.5, 4.5)

func _on_up_released():
	lock_pick.velocity.y = 0

func _on_down_released():
	lock_pick.velocity.y = 0


func _on_area_area_entered(area):
	area_colidindo = area
	
	if area == area_certa:
		passou_efeito.play()
	
	print("cadeado: area que esta colidindo: " + str(area))


func _on_timer_timeout():
	label_feedBack.visible = false
	label_feedBack.global_position = position_ini_feedback

func _quantidade_de_acertos() ->int:
	return acertos

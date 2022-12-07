extends Spatial


var enemy = preload("res://Assets/entities/enemies/enemy1/enemy1.tscn")
var enemy2 = preload("res://Assets/entities/enemies/enemy2/enemy2.tscn")
var enemy3 = preload("res://Assets/entities/enemies/enemy3/enemy3.tscn")

var wave_node = preload("res://Assets/ui/Ingame/wave/wave.tscn")

var wave : int = 0

onready var spawnTimer = $EnemySpawnCooldown
onready var waveTimer = $WaveTimer
onready var enemy_group = get_node("../EnemieGroup")
onready var player = get_node("../Player")

onready var spawnerAmount = self.get_child_count() - 2

#kijkt hoeveel children deze node heeft
#hij heeft er altijd 3 en dat is de spawnTimer alle andere zijn de spawnpoints. en we willen weten
#hoeveel spawnpoints er zijn zodat ze allemaal gekozen kunnen worden
#en er moet onready voor anders gaat ie ze al tellen voordat godot ze allemaal aangemaakt heeft


#called when the node enters the scene tree for the first time.
func _ready():
	_on_WaveTimer_timeout()
	_on_EnemySpawnCooldown_timeout()


func _on_EnemySpawnCooldown_timeout():
	var spawnPoint = Globals.random_num(1, spawnerAmount + 1)
	spawnPoint = floor(spawnPoint)
	var spawnPointNode = get_node("./SpawnPoint%s" % spawnPoint)
	
	var e = enemy.instance()
	enemy_group.add_child(e)
	e.translation = Vector3(spawnPointNode.translation)


	

func _on_WaveTimer_timeout():
	waveTimer.wait_time += 2.5
	wave += 1
	var wave_instance = wave_node.instance()
	wave_instance.wave = wave
	add_child(wave_instance)
	#restory players to max
	player.hp = 100
	spawnTimer.wait_time = 2 / (float(wave)/10 + 1)

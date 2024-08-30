extends Node2D

@onready var viewport = get_node('SubViewport')
@onready var timer = get_node('Timer')

var wc = WorldConfiguration.new()
var texture 

func _ready():
	viewport.size = Vector2(wc.terrain_masks_texture_size, wc.terrain_masks_texture_size)
	texture = viewport.get_texture()
	
	timer.timeout.connect(generate_rainfall_map.bind())
	timer.start()
	
func generate_rainfall_map():
	var image = texture.get_image()
	var image_texture = ImageTexture.create_from_image(image)
	
	var path = "res://Images/HumidityMap.tres"
	ResourceSaver.save(image_texture, path)
	print('Saved Image')
	
	

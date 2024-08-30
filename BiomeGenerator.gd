extends Node2D

@onready var viewport1 = get_node('SubViewport')
@onready var viewport2 = get_node('SubViewport2')
@onready var viewport3 = get_node('SubViewport3')
@onready var timer = get_node('Timer')

var wc = WorldConfiguration.new()
var texture1
var texture2
var texture3

func _ready():
	viewport1.size = Vector2(wc.terrain_masks_texture_size, wc.terrain_masks_texture_size)
	viewport2.size = Vector2(wc.terrain_masks_texture_size, wc.terrain_masks_texture_size)
	viewport3.size = Vector2(wc.terrain_masks_texture_size, wc.terrain_masks_texture_size)
	
	texture1 = viewport1.get_texture()
	texture2 = viewport2.get_texture()
	texture3 = viewport3.get_texture()
	
	timer.timeout.connect(generate_biome_maps.bind())
	timer.start()
	
	
func generate_biome_maps():
	var image1 = texture1.get_image()
	var image1_texture = ImageTexture.create_from_image(image1)
	var image2 = texture2.get_image()
	var image2_texture = ImageTexture.create_from_image(image2)
	var image3 = texture3.get_image()
	var image3_texture = ImageTexture.create_from_image(image3)
	
	var path1 = "res://Images/BiomeMap1.tres"
	var path2 = "res://Images/BiomeMap2.tres"
	var path3 = "res://Images/BiomeMap3.tres"
	
	
	ResourceSaver.save(image1_texture, path1)
	ResourceSaver.save(image2_texture, path2)
	ResourceSaver.save(image3_texture, path3)
	print('Biome Maps Saved')
	
	
	

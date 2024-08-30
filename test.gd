extends Node2D

var biome1 = preload("res://Images/BiomeMap1.tres")
var biome2 = preload("res://Images/BiomeMap2.tres")
var biome3 = preload('res://Images/BiomeMap3.tres')

var image1
var image2
var image3


# Called when the node enters the scene tree for the first time.
func _ready():
	image1 = biome1.get_image()
	image2 = biome2.get_image()
	image3 = biome3.get_image()
	
	print(get_weights(2, 1000))
	
	pass # Replace with function body.

func get_weights(x, z):
	var weights1: Color = image1.get_pixel(x, z)
	var weights2: Color = image2.get_pixel(x, z)
	var weights3: Color = image3.get_pixel(x, z)
	
	var weights = [
		weights1.r, weights1.g, weights1.b,
		weights2.r, weights2.g, weights2.b,
		weights3.r, weights3.g
	]
	
	return weights

# Este script podría ser un singleton autoload llamado "CraftingDatabase"
extends Node

var ingredient_prices = {
	"Egg": 100,
	"Milk": 120,
	"Sugar": 120,
	"Cone": 75,
	"Vanilla": 250,
}
# Base de datos central de crafteo
var recipes = {
	"SweetCream": {
		"station": "Mixer",
		"recipe": [
			{"name": "Milk", "quantity": 2},
			{"name": "Egg", "quantity": 1},
			{"name": "Sugar", "quantity": 1},
			{"name": "Vanilla", "quantity": 1},
		],
		"product": {
			"nombre": "SweetCream", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/SweetCream.png")
		}
	},
	"CookedCream": {
		"station": "Pot",
		"recipe": [
			{"name": "SweetCream", "quantity": 2},
		],
		"product": {
			"nombre": "CookedCream", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/CookedCream.png")
		}
	},
	"IceCreamBox": {
		"station": "Freezer",
		"recipe": [
			{"name": "CookedCream", "quantity": 2},
		],
		"product": {
			"nombre": "IceCreamBox", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/IceCreamBox.png")
		}
	},
	"IceCream": {
		"station": "ServeStation",
		"recipe": [
			{"name": "IceCreamBox", "quantity": 1},
			{"name": "Cone", "quantity": 2},
		],
		"product": {
			"nombre": "IceCream", 
			"cantidad": 2, 
			"icono": preload("res://Assets/Ingredients/IceCream.png")
		}
	},
}

# Iconos de ingredientes para reutilización
var ingredient_icons = {
	"Egg": preload("res://Assets/Ingredients/Egg.png"),
	"Milk": preload("res://Assets/Ingredients/Milk.png"),
	"Sugar": preload("res://Assets/Ingredients/Sugar.png"),
	"Cone": preload("res://Assets/Ingredients/Cone.png"),
	"Vanilla": preload("res://Assets/Ingredients/Vanilla.png"),
	"SweetCream": preload("res://Assets/Ingredients/SweetCream.png"),
	"CookedCream": preload("res://Assets/Ingredients/CookedCream.png"),
	"IceCreamBox": preload("res://Assets/Ingredients/IceCreamBox.png"),
	"IceCream": preload("res://Assets/Ingredients/IceCream.png"),
	# Añade más ingredientes aquí
}

# Obtener todas las recetas disponibles para una estación específica
func get_recipes_for_station(station_name):
	var station_recipes = []
	
	for product_name in recipes:
		var recipe_data = recipes[product_name]
		if recipe_data["station"] == station_name:
			station_recipes.append({
				"product_name": product_name,
				"recipe": recipe_data["recipe"],
				"product": recipe_data["product"]
			})
	
	return station_recipes

# Obtener la receta para un producto específico
func get_recipe_for_product(product_name):
	if product_name in recipes:
		return recipes[product_name]["recipe"]
	return null

# Obtener el icono de un ingrediente
func get_ingredient_icon(ingredient_name):
	if ingredient_name in ingredient_icons:
		return ingredient_icons[ingredient_name]
	return null

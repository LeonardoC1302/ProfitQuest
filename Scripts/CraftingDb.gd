# Este script podría ser un singleton autoload llamado "CraftingDatabase"
extends Node

var ingredient_prices = {
	# Level 1
	"Egg": 100,
	"Milk": 120,
	"Sugar": 120,
	"Cone": 75,
	"Vanilla": 250,
	
	# Level 2
	"Fish": 300,
	"Rice": 100,
	"Shrimp": 400,
	"Soy": 200,
	"Ginger": 200,
	"Wasabi": 500,
	"Algae": 300,
	"Cucumber": 100,
}
# Base de datos central de crafteo
var recipes = {
	# Level 1
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
	
	# Level 2
	"Fillet": {
		"station": "CuttingStation",
		"recipe": [
			{"name": "Fish", "quantity": 1}
		],
		"product": {
			"nombre": "Fillet", 
			"cantidad": 2, 
			"icono": preload("res://Assets/Ingredients/sushi_level/fillet.png")
		}
	},
	"CookedRice": {
		"station": "RiceCooker",
		"recipe": [
			{"name": "Rice", "quantity": 2}
		],
		"product": {
			"nombre": "CookedRice", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/sushi_level/cooked_rice.png")
		}
	},
	"Sashimi": {
		"station": "SashimiBoard",
		"recipe": [
			{"name": "Fillet", "quantity": 2},
			{"name": "Shrimp", "quantity": 1},
			{"name": "Soy", "quantity": 1},
			{"name": "Ginger", "quantity": 1},
			{"name": "Wasabi", "quantity": 1},
		],
		"product": {
			"nombre": "Sashimi", 
			"cantidad": 2, 
			"icono": preload("res://Assets/Ingredients/sushi_level/sashimi.png")
		}
	},
	"Sushi": {
		"station": "SushiBoard",
		"recipe": [
			{"name": "CookedRice", "quantity": 6},
			{"name": "Algae", "quantity": 2},
			{"name": "Fillet", "quantity": 4},
			{"name": "Cucumber", "quantity": 3},
			{"name": "Soy", "quantity": 3},
		],
		"product": {
			"nombre": "Sushi", 
			"cantidad": 5, 
			"icono": preload("res://Assets/Ingredients/sushi_level/sushi.png")
		}
	},
	
	# Level 3
}

# Iconos de ingredientes para reutilización
var ingredient_icons = {
	# Level 1
	"Egg": preload("res://Assets/Ingredients/Egg.png"),
	"Milk": preload("res://Assets/Ingredients/Milk.png"),
	"Sugar": preload("res://Assets/Ingredients/Sugar.png"),
	"Cone": preload("res://Assets/Ingredients/Cone.png"),
	"Vanilla": preload("res://Assets/Ingredients/Vanilla.png"),
	"SweetCream": preload("res://Assets/Ingredients/SweetCream.png"),
	"CookedCream": preload("res://Assets/Ingredients/CookedCream.png"),
	"IceCreamBox": preload("res://Assets/Ingredients/IceCreamBox.png"),
	"IceCream": preload("res://Assets/Ingredients/IceCream.png"),
	
	# Level 2
	"Fish": preload("res://Assets/Ingredients/sushi_level/fish.png"),
	"Rice": preload("res://Assets/Ingredients/sushi_level/rice.png"),
	"Shrimp": preload("res://Assets/Ingredients/sushi_level/shrimp.png"),
	"Soy": preload("res://Assets/Ingredients/sushi_level/soy_sauce.png"),
	"Ginger": preload("res://Assets/Ingredients/sushi_level/ginger.png"),
	"Wasabi": preload("res://Assets/Ingredients/sushi_level/wasabi.png"),
	"Algae": preload("res://Assets/Ingredients/sushi_level/algae.png"),
	"Cucumber": preload("res://Assets/Ingredients/sushi_level/cucumber.png"),
	"Fillet": preload("res://Assets/Ingredients/sushi_level/fillet.png"),
	"CookedRice": preload("res://Assets/Ingredients/sushi_level/cooked_rice.png"),
	"Sashimi": preload("res://Assets/Ingredients/sushi_level/sashimi.png"),
	"Sushi": preload("res://Assets/Ingredients/sushi_level/sushi.png"),
	
	# Level 3
	
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

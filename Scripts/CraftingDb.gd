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
	
	# Level 3
	"Beef": 250,
	"Bread": 80,
	"Cheese": 120,
	"Lettuce": 60,
	"Tomato": 70,
	"Flour": 90,
	"Sausage": 200,
	"Potato": 100,
	"Oil": 150,
	"Onion": 50,
	"Sauce": 110,
	
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
	"Dough": {
		"station": "MixingStation",
		"recipe": [
			{"name": "Flour", "quantity": 2},
			{"name": "Oil", "quantity": 1},
		],
		"product": {
			"nombre": "Dough", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/dough.png")
		}
	},
	"CookedBeef": {
		"station": "Grill",
		"recipe": [
			{"name": "Beef", "quantity": 1},
		],
		"product": {
			"nombre": "CookedBeef", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/cooked_beef.png")
		}
	},
	"CookedSausage": {
		"station": "Pan",
		"recipe": [
			{"name": "Sausage", "quantity": 1},
		],
		"product": {
			"nombre": "CookedSausage", 
			"cantidad": 1, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/cooked_sausage.png")
		}
	},
	"Burger": {
		"station": "BurgerBoard",
		"recipe": [
			{"name": "Bread", "quantity": 2},
			{"name": "CookedBeef", "quantity": 1},
			{"name": "Cheese", "quantity": 1},
			{"name": "Lettuce", "quantity": 2},
			{"name": "Tomato", "quantity": 1},
			{"name": "Sauce", "quantity": 1}
		],
		"product": {
			"nombre": "Burger", 
			"cantidad": 3, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/burger.png")
		}
	},
	"Pizza": {
		"station": "Oven",
		"recipe": [
			{"name": "Dough", "quantity": 1},
			{"name": "Cheese", "quantity": 2},
			{"name": "Tomato", "quantity": 1},
			{"name": "Sauce", "quantity": 1}
		],
		"product": {
			"nombre": "Pizza", 
			"cantidad": 4, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/pizza.png")
		}
	},
	"Hotdog": {
		"station": "HotdogStation",
		"recipe": [
			{"name": "Bread", "quantity": 1},
			{"name": "CookedSausage", "quantity": 1},
			{"name": "Onion", "quantity": 1},
			{"name": "Sauce", "quantity": 1}
		],
		"product": {
			"nombre": "Hotdog", 
			"cantidad": 2, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/hotdog.png")
		}
	},
	"Fries": {
		"station": "Fryer",
		"recipe": [
			{"name": "Potato", "quantity": 3},
			{"name": "Oil", "quantity": 2},
		],
		"product": {
			"nombre": "Fries", 
			"cantidad": 4, 
			"icono": preload("res://Assets/Ingredients/fast_food_level/fries.png")
		}
	},
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
	"Beef": preload("res://Assets/Ingredients/fast_food_level/raw_beef.png"),
	"Bread": preload("res://Assets/Ingredients/fast_food_level/bread.png"),
	"Cheese": preload("res://Assets/Ingredients/fast_food_level/cheese.png"),
	"Lettuce": preload("res://Assets/Ingredients/fast_food_level/lettuce.png"),
	"Tomato": preload("res://Assets/Ingredients/fast_food_level/tomato.png"),
	"Flour": preload("res://Assets/Ingredients/fast_food_level/flour.png"),
	"Sausage": preload("res://Assets/Ingredients/fast_food_level/raw_sausage.png"),
	"Potato": preload("res://Assets/Ingredients/fast_food_level/potato.png"),
	"Oil": preload("res://Assets/Ingredients/fast_food_level/oil.png"),
	"Onion": preload("res://Assets/Ingredients/fast_food_level/onion.png"),
	"Sauce": preload("res://Assets/Ingredients/fast_food_level/sauce.png"),
	"Dough": preload("res://Assets/Ingredients/fast_food_level/dough.png"),
	"CookedBeef": preload("res://Assets/Ingredients/fast_food_level/cooked_beef.png"),
	"CookedSausage": preload("res://Assets/Ingredients/fast_food_level/cooked_sausage.png"),
	"Burger": preload("res://Assets/Ingredients/fast_food_level/burger.png"),
	"Pizza": preload("res://Assets/Ingredients/fast_food_level/pizza.png"),
	"Hotdog": preload("res://Assets/Ingredients/fast_food_level/hotdog.png"),
	"Fries": preload("res://Assets/Ingredients/fast_food_level/fries.png"),
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

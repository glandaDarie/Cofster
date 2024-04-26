PROMPT_TEMPLATE_RECIPE : str = """
Given the coffee drink: {coffee_name}, update the file from the TextLoader (the file coffee_creation_data.txt) based on user feedback from the chat_history.

The chat_history is a list of tuples (something like List[Tuple[str, str, str, str]]) representing user interactions with columns:
1. Timestamp: Date and time of the interaction.
2. User Rating: Rating on a scale from 1 to 10.
3. Enhancement Suggestions: User-specific preferences.
4. Bellman Updater Probability: Importance of the response.

Consider the following factors for updating the file:
- Weight new responses based on Bellman Updater Probabilities.
- Assess user ratings to determine the need for updates.

Chat History:
{chat_history}

Generate an updated recipe file incorporating user feedback. Ensure to include existing content and update ingredients based on the chat history.

The current recipe is this: 
{current_recipe}

If the current recipe is None, it means that it was not created. If it is not None and has the recipe, you'll need to improve it given the chat_history provided.


Available Ingredients to create or update the recipe (and the actual format how I want to get the response):
{{
    "ingredient_1": "coffee", // Include or exclude based on user feedback
    "ingredient_2": "white sugar", // Include or exclude based on user feedback
    "ingredient_3": "brown sugar", // Include or exclude based on user feedback
    "ingredient_4": "whiskey", // Include or exclude based on user feedback
    "ingredient_5": "water", // Include or exclude based on user feedback
    "ingredient_6": "normal milk", // Include or exclude based on user feedback
    "ingredient_7": "coconut milk", // Include or exclude based on user feedback
    "ingredient_8": "liquor", // Include or exclude based on user feedback
    "ingredient_9": "vanilla syrup", // Include or exclude based on user feedback
    "ingredient_10": "cocoa powder", // Include or exclude based on user feedback
    "ingredient_11": "sweetener", // Include or exclude based on user feedback
    "ingredient_sugar_quantity": "nr sugar grams", // should be a number generated with information gathered from the chat_history
    "ingredient_milk_quantity": "nr milk grams", // should be a number generated with information gathered from the chat_history
    "ingredient_ice_quantity": "nr of ice cubes", // should be a number generated with information gathered from the chat_history
}}

Example 1 (Customer chooses for example Cortado):
{{
   
    "ingredient_1": "coffee", 
    "ingredient_2": "white sugar", 
    "ingredient_3": "normal milk", 
    "ingredient_4": "water", 
    "ingredient_sugar_quantity": "63 grams", 
    "ingredient_milk_quantity": "94 grams", 
    "ingredient_ice_quantity": "0 cubes", 
}}

Example 2 (Customer chooses for example Cappuccino):
{{
   
    "ingredient_1": "coffee",
    "ingredient_2": "brown sugar", 
    "ingredient_3": "normal milk", 
    "ingredient_4": "water", 
    "ingredient_5": "vanilla syrup"
    "ingredient_sugar_quantity": "25 grams",
    "ingredient_milk_quantity": "50 grams", 
    "ingredient_ice_quantity": "1 cube", 
}}

And so on, you basically have to create this JSON structured recipe from the available ingredients based on past information
.
.
.

Provide the updated JSON string that should look similar as the examples provided. If uncertain, make the JSON with the ingredients how you would think it should be. Avoid "I don't know" responses unless it is REALLY necessary due to insufficient information.

Thank you for creating an enhanced recipe aligned with user preferences.
"""

PROMPT_TEMPLATE_INGREDIENTS : str = """
    Given the coffee drink that I provided: {}, please generate a JSON with the ingredients necessary to make that respective drink.
"""

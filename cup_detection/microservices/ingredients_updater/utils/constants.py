# PROMPT_TEMPLATE_RECIPE : str = """
# Given the coffee drink: {coffee_name}, update the provided file to the TextLoader (the coffee_creation_data.txt) by leveraging information from the chat_history.
# The chat_history, converted from PostgreSQL SELECT responses to List[Tuple[str, str, str, str]], includes Bellman updater probabilities (found in the last column). It represents user feedback on the respective drink.

# The chat_history columns:
# 1. **Timestamp:** Date and time of the customer's interaction.
# 2. **User Rating (question_1):** User rates the drink on a scale from 1 to 10.
# 3. **Enhancement Suggestions (question_2):** User-specific update preferences.
# 4. **Bellman Updater Probability:** Probability assigned by the Bellman updater, indicating the importance of the user's response.

# Consider the following factors for updating the file:
# 1. **Bellman Updater Probabilities:** Assign a higher weight to newer responses.
# 2. **User Ratings:** Based on this, it should be deduced if updates on the respective file should be needed or not, with the information gathered from the chat_history.

# This is the chat_history: {chat_history}

# Where The column inside this List[Tuple] that represents a questionnaire entity are: 

# column 1 - timestamp (the current date + time - was for sorting to fetch the newest responses only)
# column 2 - question 1 (the response of the customer to the first question)
# column 3 - question 2 (the response of the customer to the second question)
# column 4 - probability (the probability using the bellman equation to assign more importance to the newest questions - bigger probability means that the respective response is more important)

# Generate the updated file with small changes:
# Read the existing file content and add additional information based on user feedback. Update the ingredients only for the specified coffee drink, considering the information gathered from the chat_history.

# Display the ingredients and the ingredient quantity, for the respective cordato coffee drink, given the feedback in chat_history. 

# These are all the options:
# {{
#     "ingredient_1": "coffee", // Include or exclude based on user feedback
#     "ingredient_2": "white sugar", // Include or exclude based on user feedback
#     "ingredient_3": "brown sugar", // Include or exclude based on user feedback
#     "ingredient_4": "whiskey", // Include or exclude based on user feedback
#     "ingredient_5": "water", // Include or exclude based on user feedback
#     "ingredient_6": "normal milk", // Include or exclude based on user feedback
#     "ingredient_7": "coconut milk", // Include or exclude based on user feedback
#     "ingredient_8": "liquor", // Include or exclude based on user feedback
#     "ingredient_9": "chocolate syrup", // Include or exclude based on user feedback
#     "ingredient_10": "cocoa powder", // Include or exclude based on user feedback
#     "ingredient_11": "sweetener", // Include or exclude based on user feedback
#     "ingredient_sugar_quantity": "nr sugar grams", // should be a number generated with information gathered from the chat_history
#     "ingredient_milk_quantity": "nr milk grams", // should be a number generated with information gathered from the chat_history
#     "ingredient_ice_quantity": "nr of ice cubes", // should be a number generated with information gathered from the chat_history
# }}

# Example 1:
# {{
   
#     "ingredient_1": "coffee", 
#     "ingredient_2": "white sugar", 
#     "ingredient_3": "normal milk", 
#     "ingredient_4": "water", 
#     "ingredient_sugar_quantity": "100 grams", 
#     "ingredient_milk_quantity": "100 grams", 
#     "ingredient_ice_quantity": "0 cubes", 
# }}

# Example 2:
# {{
   
#     "ingredient_1": "coffee",
#     "ingredient_2": "brown sugar", 
#     "ingredient_3": "brown sugar",
#     "ingredient_4": "water", 
#     "ingredient_sugar_quantity": "25 grams",
#     "ingredient_milk_quantity": "50 grams", 
#     "ingredient_ice_quantity": "1 cube", 
# }}

# .
# .
# .

# or anything else (you should do the ingredients based on the chat history and the text prompt provided beforehand).

# Ensure that you also add the rest of the content from the file, so it will not lose its context. Ensure also that all the content for the file will be of type string.

# The goal is to generate an enhanced recipe for the coffee drink that aligns with user preferences and feedback, considering the chat_history passed in this prompt and GPT-3.5 response.

# If you don't think you have sufficient information, or don't understand what to do, return strictly this: I don't know.  

# Thank you for ensuring that the updates align with user preferences and feedback.
# """

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

If the current recipe is None, it means that it was not created, while if it not not None and has JSON, that is the recipe that you need to improve given the chat_history provided.


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

Provide detailed updates reflecting user preferences and feedback. If uncertain, propose informed changes based on available data. Avoid "I don't know" responses unless it is REALLY necessary due to insufficient information.

Thank you for creating an enhanced recipe aligned with user preferences.
"""

PROMPT_TEMPLATE_INGREDIENTS : str = """
    Given the coffee drink that I provided: {}, please generate a JSON with the ingredients necessary to make that respective drink.
"""

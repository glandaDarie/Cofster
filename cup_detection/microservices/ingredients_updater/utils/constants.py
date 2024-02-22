# PROMPT_TEMPLATE : str = """ 
# Given the coffee drink: cortado, update the provided file by leveraging the information in the chat history. 
# The chat history contains responses, including Bellman updater probabilities (found in the last column), and only the latest 20 interactions.

# Consider the following factors for updating the file:

# 1. **Bellman Updater Probabilities:** Assign higher weight to newer responses due to the Bellman updater.

# 2. **User Ratings:** Users can rate the coffee drink on a scale from 1 to 10. Use these ratings for updating:
#    - If a user liked the coffee drink (based on the rating), enhance the recipe accordingly.
#    - If a user did not like the coffee drink, review the provided information on how to update the drink. Adjust the update direction accordingly.

# Ensure that the file is updated coherently, taking into account:
# - Weights from the Bellman updater,
# - Chronological importance of responses,
# - User ratings.

# The goal is to generate an improved recipe for the coffee drink that aligns with user preferences and feedback.

# Thank you for ensuring that the updates align with user preferences and feedback.
# """

# PROMPT_TEMPLATE : str = """ 
# Given the coffee drink: {}, update the provided file by leveraging the information in the chat history. 
# The chat history contains responses, including Bellman updater probabilities (found in the last column), and only the latest 20 interactions.

# Consider the following factors for updating the file:

# 1. **Bellman Updater Probabilities:** Assign higher weight to newer responses due to the Bellman updater.

# 2. **User Ratings:** Users can rate the coffee drink on a scale from 1 to 10. Use these ratings for updating:
#    - If a user liked the coffee drink (based on the rating), enhance the recipe accordingly.
#    - If a user did not like the coffee drink, review the provided information on how to update the drink. Adjust the update direction accordingly.

# Ensure that the file is updated coherently, taking into account:
# - Weights from the Bellman updater,
# - Chronological importance of responses,
# - User ratings.

# The goal is to generate an improved recipe for the coffee drink that aligns with user preferences and feedback.

# Thank you for ensuring that the updates align with user preferences and feedback.
# """


# PROMPT_TEMPLATE = """
# Given the coffee drink: cortado, update the provided file by leveraging information from the chat history. 
# The chat history contains responses, including Bellman updater probabilities (found in the last column), and only the latest 20 interactions.

# Consider the following factors for updating the file:

# 1. **Bellman Updater Probabilities:** Assign higher weight to newer responses due to the Bellman updater.

# 2. **User Ratings:** Users can rate the coffee drink on a scale from 1 to 10. Use these ratings for updating:
#    - If a user liked the coffee drink (based on the rating), enhance the recipe accordingly.
#    - If a user did not like the coffee drink, review the provided information on how to update the drink. Adjust the update direction accordingly.

# Ensure that the file is updated coherently, taking into account:
# - Weights from the Bellman updater,
# - Chronological importance of responses,
# - User ratings.

# Provide autoregressive instructions to guide the model in generating an improved recipe. For each question_1 and question_2 in the chat history, 
# incorporate the timestamp and corresponding Bellman updater probability.

# ---

# Autoregressive Instructions:
# {autoregressive_instructions}

# ---

# The goal is to generate an enhanced the recipe for the coffee drink that aligns with user preferences and feedback.

# Thank you for ensuring that the updates align with user preferences and feedback.
# """

PROMPT_TEMPLATE : str = """
Given the coffee drink: cortado, update the provided file to the TextLoader (the coffee_creation_data.txt) by leveraging information from the chat history. 
The chat_history, where data is converted from PostgreSQL SELECT responses to List[Tuple[str, str, str, str]], contains the converted responses, \
including Bellman updater probabilities (found in the last column). Those responses (the chat_history), are the formular drink responses, for each customer that \
has an account created, and it basically represents how much the user liked the given drink. 

The columns in the chat history are as follows:
1. **Timestamp:** Represents the date and time of the customer's interaction, indicating when the user provided feedback.
2. **User Rating (question_1):** Indicates how well the user rates the coffee drink on a scale from 1 to 10. From 8 upwards, it basically means that the user liked the drink.
3. **Enhancement Suggestions (question_2):** Describes any enhancements the user suggests for the coffee drink. This is a textbox input capturing user-specific update preferences.
4. **Bellman Updater Probability:** Represents the probability assigned by the Bellman updater, indicating the importance of the user's response. Newer responses have higher probabilities, \
meaning that they should hold the biggest weight when updating the file from the TextLoader (the coffee_creation_data.txt file).

Consider the following factors for updating the file:

1. **Bellman Updater Probabilities:** Assign a higher weight to newer responses due to the Bellman updater.
2. **User Ratings:** Users can rate the coffee drink on a scale from 1 to 10. Use these ratings for updating:
   - If a user liked the coffee drink (based on the rating), change only slightly based on the second question answer and also providing the score from 1-10.
   - If a user did not like the coffee drink, update the drink given the chat_history responses provided from the question_1 and question_2. Keep in ming the Bellman update rule.

Ensure that the file is updated coherently, taking into account:
- Weights from the Bellman updater,
- Chronological importance of responses,
- User ratings.

Provide autoregressive instructions to guide the model in generating an improved recipe. For each question_1 and question_2 in the chat history, 
incorporate the timestamp and corresponding Bellman updater probability, slightly favoring changes requested by that user.

The goal is to generate an enhanced recipe for the given drink that aligns with user preferences and feedback.

Please generate the prompt either way, even if you are not sure if it is correct of what I said.

Thank you for ensuring that the updates align with user preferences and feedback.
"""

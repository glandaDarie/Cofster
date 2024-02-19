PROMPT_TEMPLATE : str = """ 
Given the coffee drink: cortado, update the provided file by leveraging the information in the chat history. 
The chat history contains responses, including Bellman updater probabilities (found in the last column), and only the latest 20 interactions.

Consider the following factors for updating the file:

1. **Bellman Updater Probabilities:** Assign higher weight to newer responses due to the Bellman updater.

2. **User Ratings:** Users can rate the coffee drink on a scale from 1 to 10. Use these ratings for updating:
   - If a user liked the coffee drink (based on the rating), enhance the recipe accordingly.
   - If a user did not like the coffee drink, review the provided information on how to update the drink. Adjust the update direction accordingly.

Ensure that the file is updated coherently, taking into account:
- Weights from the Bellman updater,
- Chronological importance of responses,
- User ratings.

The goal is to generate an improved recipe for the coffee drink that aligns with user preferences and feedback.

Thank you for ensuring that the updates align with user preferences and feedback.
"""

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

import argparse
import sys

sys.path.append("../")

class ArgumentParser:
    @staticmethod
    def get_recipe_arguments() -> argparse.Namespace:
        """
        Returns parsed arguments related to recipe.

        Returns:
        - argparse.Namespace: Parsed arguments related to recipe.
        """
        parser: argparse.ArgumentParser = argparse.ArgumentParser(description="Cofster - Drink Creation Service")
        parser.add_argument("--llm_recipe", action="store_true", help="Enable LLM Recipe")
        return parser.parse_args()
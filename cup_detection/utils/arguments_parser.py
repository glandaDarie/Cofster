import argparse

class ArgumentParser:
    @staticmethod
    def get_arguments():
        parser : argparse.ArgumentParser = argparse.ArgumentParser(description="Cofster - Drink Creation Service")
        parser.add_argument("--llm_recipe", action="store_true", help="Enable LLM Recipe")
        return parser.parse_args()
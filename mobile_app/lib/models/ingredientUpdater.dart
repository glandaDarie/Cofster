class IngredientUpdater {
  Map<String, dynamic> _ingredientUpdater = {};
  IngredientUpdater(Map<String, dynamic> ingredientUpdater)
      : this._ingredientUpdater = Map.from(ingredientUpdater);

  Map<String, dynamic> get ingredientUpdater => this._ingredientUpdater;

  void set ingredientUpdater(Map<String, dynamic> newIngredientUpdater) =>
      this._ingredientUpdater = newIngredientUpdater;

  @override
  String toString() {
    return "ingredientUpdater: ${ingredientUpdater}";
  }
}

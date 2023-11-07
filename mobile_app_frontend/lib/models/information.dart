class Information {
  List<String> _ingredients;
  String _preparationTime;
  List<String> _nutritionInformation;

  Information(List<String> ingredients, String preparationTime,
      List<String> nutritionInformation) {
    this._ingredients = List.from(ingredients);
    this._preparationTime = preparationTime;
    this._nutritionInformation = List.from(nutritionInformation);
  }

  List<String> get ingredients => List.from(this._ingredients);
  String get preparationTime => this._preparationTime;
  List<String> get nutritionInformation => this._nutritionInformation;

  set ingredients(List<String> _value) => this._ingredients = List.from(_value);
  set preparationTime(String _value) => this._preparationTime = _value;
  set nutritionInformation(List<String> _value) =>
      this._nutritionInformation = List.from(_value);

  @override
  String toString() {
    return "${this._ingredients} ${this._preparationTime} ${this._nutritionInformation}";
  }
}

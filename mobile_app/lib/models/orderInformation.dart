class OrderInformation {
  String _coffeeName;
  String _coffeePrice;
  DateTime _coffeeOrderTime;
  DateTime _coffeeEstimationTime;

  OrderInformation(this._coffeeName, this._coffeePrice, this._coffeeOrderTime,
      [this._coffeeEstimationTime]);

  String get coffeeName => this._coffeeName;
  String get coffeePrice => this._coffeePrice;
  DateTime get coffeeOrderTime => this._coffeeOrderTime;
  DateTime get coffeeEstimationTime => this._coffeeEstimationTime;

  void set coffeeName(String coffeeName) => this._coffeeName = coffeeName;
  void set coffeePrice(String coffeePrice) => this._coffeePrice = coffeePrice;
  void set coffeeOrderTime(DateTime coffeeOrderTime) =>
      this._coffeeOrderTime = coffeeOrderTime;
  void set coffeeEstimationTime(DateTime coffeeEstimationTime) =>
      this._coffeeEstimationTime = coffeeEstimationTime;

  @override
  String toString() {
    return "${this._coffeeName} ${this._coffeePrice} ${this._coffeeOrderTime} ${this._coffeeEstimationTime}";
  }
}

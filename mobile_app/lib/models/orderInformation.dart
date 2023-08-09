class OrderInformation {
  String _coffeeName;
  String _coffeePrice;
  String _communication;
  int _coffeeStatus;
  DateTime _coffeeOrderTime;
  DateTime _coffeeEstimationTime;

  OrderInformation(this._coffeeName, this._coffeePrice, this._communication,
      this._coffeeStatus, this._coffeeOrderTime,
      [this._coffeeEstimationTime]);

  String get coffeeName => this._coffeeName;
  String get coffeePrice => this._coffeePrice;
  String get communication => this._communication;
  int get coffeStatus => this._coffeeStatus;
  DateTime get coffeeOrderTime => this._coffeeOrderTime;
  DateTime get coffeeEstimationTime => this._coffeeEstimationTime;

  void set coffeeName(String coffeeName) => this._coffeeName = coffeeName;
  void set coffeePrice(String coffeePrice) => this._coffeePrice = coffeePrice;
  void set coffeStatus(int coffeStatus) => this._coffeeStatus = coffeStatus;
  void set communication(String communication) =>
      this._communication = communication;
  void set coffeeOrderTime(DateTime coffeeOrderTime) =>
      this._coffeeOrderTime = coffeeOrderTime;
  void set coffeeEstimationTime(DateTime coffeeEstimationTime) =>
      this._coffeeEstimationTime = coffeeEstimationTime;

  @override
  String toString() {
    return "${this._coffeeName} ${this._coffeePrice} ${this._communication} ${this.coffeStatus} ${this._coffeeOrderTime} ${this._coffeeEstimationTime}";
  }
}

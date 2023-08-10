class OrderInformation {
  String _keyId;
  String _coffeeName;
  String _coffeePrice;
  int _quantity;
  String _communication;
  int _coffeeStatus;
  String _coffeeOrderTime;
  String _coffeeEstimationTime;

  OrderInformation(
      this._keyId,
      this._coffeeName,
      this._coffeePrice,
      this._quantity,
      this._communication,
      this._coffeeStatus,
      this._coffeeOrderTime,
      this._coffeeEstimationTime);

  String get keyId => this._keyId;
  String get coffeeName => this._coffeeName;
  String get coffeePrice => this._coffeePrice;
  int get quantity => this._quantity;
  String get communication => this._communication;
  int get coffeStatus => this._coffeeStatus;
  String get coffeeOrderTime => this._coffeeOrderTime;
  String get coffeeEstimationTime => this._coffeeEstimationTime;

  void set keyId(String keyId) => this._keyId = keyId;
  void set coffeeName(String coffeeName) => this._coffeeName = coffeeName;
  void set coffeePrice(String coffeePrice) => this._coffeePrice = coffeePrice;
  void set quantity(int quantity) => this._quantity = quantity;
  void set coffeStatus(int coffeStatus) => this._coffeeStatus = coffeStatus;
  void set communication(String communication) =>
      this._communication = communication;
  void set coffeeOrderTime(String coffeeOrderTime) =>
      this._coffeeOrderTime = coffeeOrderTime;
  void set coffeeEstimationTime(String coffeeEstimationTime) =>
      this._coffeeEstimationTime = coffeeEstimationTime;

  @override
  String toString() {
    return "${this._keyId} ${this._coffeeName} ${this._coffeePrice} ${this._quantity} ${this._communication} ${this.coffeStatus} ${this._coffeeOrderTime} ${this._coffeeEstimationTime}";
  }
}

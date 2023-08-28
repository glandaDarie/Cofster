class OrderInformation {
  String _keyId;
  String _coffeeName;
  String _coffeePrice;
  int _quantity;
  String _communication;
  int _coffeeStatus;
  String _coffeeOrderTime;
  String _coffeeEstimationTime;
  String _coffeeCupSize;
  String _coffeeTemperature;
  int _numberOfSugarCubes;
  int _numberOfIceCubes;
  bool _hasCream;

  OrderInformation(
      this._keyId,
      this._coffeeName,
      this._coffeePrice,
      this._quantity,
      this._communication,
      this._coffeeStatus,
      this._coffeeOrderTime,
      this._coffeeEstimationTime,
      this._coffeeCupSize,
      this._coffeeTemperature,
      this._numberOfSugarCubes,
      this._numberOfIceCubes,
      this._hasCream);

  String get keyId => this._keyId;
  String get coffeeName => this._coffeeName;
  String get coffeePrice => this._coffeePrice;
  int get quantity => this._quantity;
  String get communication => this._communication;
  int get coffeStatus => this._coffeeStatus;
  String get coffeeOrderTime => this._coffeeOrderTime;
  String get coffeeEstimationTime => this._coffeeEstimationTime;
  String get coffeeCupSize => this._coffeeCupSize;
  String get coffeeTemperature => this._coffeeTemperature;
  int get numberOfSugarCubes => this._numberOfSugarCubes;
  int get numberOfIceCubes => this._numberOfIceCubes;
  bool get hasCream => this._hasCream;

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
  void set coffeeCupSize(String coffeeCupSize) =>
      this._coffeeCupSize = coffeeCupSize;
  void set coffeeTemperature(String coffeeTemperature) =>
      this._coffeeTemperature = coffeeTemperature;
  void set numberOfSugarCubes(int numberOfSugarCubes) =>
      this._numberOfSugarCubes = numberOfSugarCubes;
  void set numberOfIceCubes(int numberOfIceCubes) =>
      this._numberOfIceCubes = numberOfIceCubes;
  void set hasCream(bool hasCream) => this._hasCream = hasCream;

  @override
  String toString() {
    return "${this._keyId} ${this._coffeeName} ${this._coffeePrice} ${this._quantity} ${this._communication} ${this.coffeStatus} ${this._coffeeOrderTime} ${this._coffeeEstimationTime}";
  }
}

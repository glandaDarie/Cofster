class OrderInformation {
  String keyId;
  String coffeeName;
  String customerName;
  String coffeePrice;
  String recipeType;
  int quantity;
  String communication;
  int coffeeStatus;
  String coffeeOrderTime;
  String coffeeEstimationTime;
  String coffeeCupSize;
  String coffeeTemperature;
  int numberOfSugarCubes;
  int numberOfIceCubes;
  bool hasCream;

  OrderInformation({
    this.keyId,
    this.coffeeName,
    this.customerName,
    this.coffeePrice,
    this.recipeType,
    this.quantity,
    this.communication,
    this.coffeeStatus,
    this.coffeeOrderTime,
    this.coffeeEstimationTime,
    this.coffeeCupSize,
    this.coffeeTemperature,
    this.numberOfSugarCubes,
    this.numberOfIceCubes,
    this.hasCream,
  });

  String get keyId_ => this.keyId;
  String get coffeeName_ => this.coffeeName;
  String get customerName_ => this.customerName;
  String get coffeePrice_ => this.coffeePrice;
  String get recipeType_ => this.recipeType;
  int get quantity_ => this.quantity;
  String get communication_ => this.communication;
  int get coffeeStatus_ => this.coffeeStatus;
  String get coffeeOrderTime_ => this.coffeeOrderTime;
  String get coffeeEstimationTime_ => this.coffeeEstimationTime;
  String get coffeeCupSize_ => this.coffeeCupSize;
  String get coffeeTemperature_ => this.coffeeTemperature;
  int get numberOfSugarCubes_ => this.numberOfSugarCubes;
  int get numberOfIceCubes_ => this.numberOfIceCubes;
  bool get hasCream_ => this.hasCream;

  void set keyId_(String keyId) => this.keyId = keyId;
  void set coffeeName_(String coffeeName) => this.coffeeName = coffeeName;
  void set customerName_(String customerName) =>
      this.customerName = customerName;
  void set coffeePrice_(String coffeePrice) => this.coffeePrice = coffeePrice;
  void set recipeType_(String recipeType) => this.recipeType = recipeType;
  void set quantity_(int quantity) => this.quantity = quantity;
  void set coffeeStatus_(int coffeeStatus) => this.coffeeStatus = coffeeStatus;
  void set communication_(String communication) =>
      this.communication = communication;
  void set coffeeOrderTime_(String coffeeOrderTime) =>
      this.coffeeOrderTime = coffeeOrderTime;
  void set coffeeEstimationTime_(String coffeeEstimationTime) =>
      this.coffeeEstimationTime = coffeeEstimationTime;
  void set coffeeCupSize_(String coffeeCupSize) =>
      this.coffeeCupSize = coffeeCupSize;
  void set coffeeTemperature_(String coffeeTemperature) =>
      this.coffeeTemperature = coffeeTemperature;
  void set numberOfSugarCubes_(int numberOfSugarCubes) =>
      this.numberOfSugarCubes = numberOfSugarCubes;
  void set numberOfIceCubes_(int numberOfIceCubes) =>
      this.numberOfIceCubes = numberOfIceCubes;
  void set hasCream_(bool hasCream) => this.hasCream = hasCream;

  @override
  String toString() {
    return "${this.keyId} ${this.coffeeName} ${this.customerName} ${this.coffeePrice} ${this.recipeType} ${this.quantity} ${this.communication} ${this.coffeeStatus} ${this.coffeeOrderTime} ${this.coffeeEstimationTime}";
  }
}

class User {
  int _id;
  String _name;
  String _username;
  String _password;
  List<String> _favouriteDrinks;
  String _photo;

  User(int _id, String _name, String _username, String _password, String _photo,
      List<String> _favouriteDrinks) {
    this._id = _id;
    this._name = _name;
    this._username = _username;
    this._password = _password;
    this._favouriteDrinks = List.from(_favouriteDrinks);
    this._photo = _photo;
  }

  int get id => this._id;
  String get name => this._name;
  String get username => this._username;
  String get password => this._password;
  List<String> get favouriteDrinks => this._favouriteDrinks;
  String get photo => this._photo;

  set id(int _value) => this._id = _value;
  set name(String _value) => this._name = _value.trim();
  set username(String _value) => this._username = _value.trim();
  set password(String _value) => this._password = _value.trim();
  set favouriteDrinks(List<String> _value) =>
      this._favouriteDrinks = List.from(_favouriteDrinks);
  set photo(String _value) => this._photo = _value.trim();

  @override
  String toString() {
    return "${this._id} ${this._name} ${this._username} ${this._password} ${this._favouriteDrinks} ${this._photo}";
  }
}

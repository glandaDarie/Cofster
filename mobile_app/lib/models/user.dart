class User {
  int _id;
  String _name;
  String _username;
  String _password;
  String _favouriteDrink;
  String _photo;

  User(int _id, String _name, String _username, String _password,
      String _favouriteDrink, String _photo) {
    this._id = _id;
    this._name = _name;
    this._username = _username;
    this._password = _password;
    this._favouriteDrink = _favouriteDrink;
    this._photo = _photo;
  }

  int get id => this._id;
  String get name => this._name;
  String get username => this._username;
  String get password => this._password;
  String get favouriteDrink => this._favouriteDrink;
  String get photo => this._photo;

  set id(int value) => this._id = value;
  set name(String value) => this._name = value.trim();
  set username(String value) => this._username = value.trim();
  set password(String value) => this._password = value.trim();
  set favouriteDrink(String value) => this._favouriteDrink = value.trim();
  set photo(String value) => this._photo = value.trim();

  @override
  String toString() {
    return "${this._id} ${this._name} ${this._username} ${this._password} ${this._favouriteDrink} ${this._photo}";
  }
}

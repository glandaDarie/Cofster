class Gift {
  String _gift;

  Gift(this._gift);

  String get gift => this._gift;

  void set gift(String gift) => this._gift = gift;

  @override
  String toString() {
    return "gift: ${this._gift}";
  }
}

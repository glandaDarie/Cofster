class LlmUpdaterQuestion {
  String _question;
  List<String> _options;
  LlmUpdaterQuestion(this._question, this._options);

  String get question => this._question;

  void set question(String _question) => this._question = _question;

  List<String> get options => this._options;

  void set options(List<String> options) => this._options = [...options];

  void addOption(String option) => this._options.add(option);

  void removeOption(int index) => this._options.removeAt(index);

  @override
  String toString() {
    return "${this._question} ${this._options}";
  }
}

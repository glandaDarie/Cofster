String timeOfOrder({int secondsDelay = 0}) {
  DateTime currentTime = DateTime.now();
  if (secondsDelay > 0) {
    DateTime estimatedTime = currentTime.add(Duration(seconds: secondsDelay));
    return "${_paddedValue(estimatedTime.hour)}:${_paddedValue(estimatedTime.minute)}:${_paddedValue(estimatedTime.second)}";
  }
  return "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";
}

String _paddedValue(int value) {
  return value < 10 ? "0${value}" : value.toString();
}

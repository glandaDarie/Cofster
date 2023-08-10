String timeOfOrder({int secondsDelay = 0}) {
  DateTime currentTime = DateTime.now();
  if (secondsDelay > 0) {
    DateTime estimatedTime = currentTime.add(Duration(seconds: secondsDelay));
    return "${estimatedTime.hour}:${estimatedTime.minute}:${estimatedTime.second}";
  }
  return "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";
}

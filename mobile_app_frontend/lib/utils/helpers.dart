String dateAndTimeFormatted(DateTime dateTime) {
  String date = dateTime.toString();
  List<String> dateAndTime = date.split(" ");
  dateAndTime[0] = dateAndTime[0].replaceAll("-", ":");
  dateAndTime[1] = dateAndTime[1].split(".")[0];
  return dateAndTime.join(" ");
}

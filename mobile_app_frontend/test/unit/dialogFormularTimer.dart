import 'package:coffee_orderer/providers/dialogFormularTimerProvider.dart'
    show DialogFormularTimerProvider;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

void main() async {
  await LoggedInService.setSharedPreferenceValue("<elapsedTime>", value: null);
  final String previousDateAndTime =
      await LoggedInService.getSharedPreferenceValue("<elapsedTime>");
  final DialogFormularTimerProvider dialogFormularTimerProvider =
      DialogFormularTimerProvider.getInstance(
          previousDateAndTime: DateTime.parse(previousDateAndTime),
          debug: true);
  dialogFormularTimerProvider.setTimer(seconds: 3);
}

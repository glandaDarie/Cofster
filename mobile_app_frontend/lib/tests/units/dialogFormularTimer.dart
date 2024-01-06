import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_orderer/providers/dialogFormularTimerProvider.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

void main() {
  test('Test setTimer method', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    bool expected = null;
    bool actual = null;
    String previousDateAndTime =
        await LoggedInService.getSharedPreferenceValue("<elapsedTime>");
    assert(previousDateAndTime == null, "Error appeard, value is not null.");
    final DialogFormularTimerProvider dialogFormularTimerProvider =
        DialogFormularTimerProvider.getInstance(
      previousDateAndTime: DateTime.parse(previousDateAndTime),
      debug: true,
    );
    expected = false;
    actual = dialogFormularTimerProvider.displayDialog;
    expect(actual, equals(expected));

    dialogFormularTimerProvider.setTimer(seconds: 3);
    expected = true;
    actual = dialogFormularTimerProvider.displayDialog;
    expect(actual, equals(expected));
  });
}

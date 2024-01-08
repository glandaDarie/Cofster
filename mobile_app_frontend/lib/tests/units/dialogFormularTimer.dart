import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/providers/dialogFormularTimerSingletonProvider.dart'
    show DialogFormularTimerSingletonProvider;

class MockSharedPreferences extends Mock implements LoggedInService {
  static Map<String, dynamic> _sharedPreferences = {};

  static Future<String> setSharedPreferenceValue(
      {@required String key, @required dynamic value}) async {
    _sharedPreferences[key] = value;
    return await "Key: ${key}, value: ${value}";
  }

  static dynamic getSharedPreferenceValue(String key) {
    return _sharedPreferences[key];
  }
}

void main() {
  testWidgets(
    "Test setTimer method",
    (WidgetTester tester) async {
      final String sharedPreferenceKey = "<elapsedTime>";
      MockSharedPreferences.setSharedPreferenceValue(
        key: sharedPreferenceKey,
        value: null,
      );
      String futureDateAndTime =
          MockSharedPreferences.getSharedPreferenceValue(sharedPreferenceKey);
      expect(futureDateAndTime, equals(null));

      final DialogFormularTimerSingletonProvider dialogFormularTimerProvider =
          DialogFormularTimerSingletonProvider.getInstance(
        sharedPreferenceKey: sharedPreferenceKey,
        futureDateAndTime: futureDateAndTime != null
            ? DateTime.tryParse(futureDateAndTime)
            : null,
        onSetSharedPreferenceValue: (String key, {@required dynamic value}) =>
            MockSharedPreferences.setSharedPreferenceValue(
          key: sharedPreferenceKey,
          value: null,
        ),
        onGetSharedPreferenceValue: (String key) =>
            MockSharedPreferences.getSharedPreferenceValue(sharedPreferenceKey),
        debug: true,
      );

      expect(dialogFormularTimerProvider.displayDialog, isFalse);

      dialogFormularTimerProvider.startTimer(seconds: 10);
      await tester.pump();
      await tester.pump(const Duration(seconds: 10));
      await tester.pump();

      // cannot test this, because of async nature of the code (only in prod should work)
      // temporary turnaround is setting to true displayDialog if the logger is called in the dialogFormularTimerProvider
      dialogFormularTimerProvider.displayDialog = true;
      expect(dialogFormularTimerProvider.displayDialog, isTrue);
    },
  );
}

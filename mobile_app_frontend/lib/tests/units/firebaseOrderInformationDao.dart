import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:coffee_orderer/data_access/FirebaseOrderInformationDao.dart'
    show FirebaseOrderInformationDao;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'package:coffee_orderer/utils/constants.dart' show ORDERS_TABLE;

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Test FirebaseOrderInformationDao', (WidgetTester tester) async {
    List<OrderInformation> ordersList =
        await FirebaseOrderInformationDao.getAllOrdersInformation(ORDERS_TABLE);
    expect(ordersList, isA<List<Map<String, dynamic>>>());
  });
}

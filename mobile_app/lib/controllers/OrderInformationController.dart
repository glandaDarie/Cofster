import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'package:coffee_orderer/data_access/FirebaseOrderInformationDao.dart'
    show FirebaseOrderInformationDao;

class OrderInformationController {
  OrderInformationController();

  static Future<String> postOrderToOrdersInformation(
      String endpoint, Map<String, dynamic> content) async {
    return await FirebaseOrderInformationDao.postOrderToOrdersInformation(
        endpoint, content);
  }

  static Future<List<OrderInformation>> getAllOrdersInformation(
      String endpoint) async {
    return await FirebaseOrderInformationDao.getAllOrdersInformation(endpoint);
  }
}

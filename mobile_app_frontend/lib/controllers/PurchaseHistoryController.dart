import 'package:coffee_orderer/data_access/DynamoDBPurchaseHistoryDao.dart';
import 'package:coffee_orderer/data_transfer/PurchaseHistoryDto.dart'
    show PurchaseHistoryDto;
import 'package:coffee_orderer/services/urlService.dart';

class PurchaseHistoryController {
  UrlService _urlServicePurchase;
  String _urlPurchase;
  DynamoDBPurchaseHistoryDao _userDaoPurchase;

  Future<List<PurchaseHistoryDto>> getUsersPurchaseHistory(
      final String email) async {
    this._urlServicePurchase = UrlService(
      "https://3nmrf0dxv8.execute-api.us-east-1.amazonaws.com/prod",
      "/purchase",
      {"email": email},
    );
    this._urlPurchase = this._urlServicePurchase.createUrl();
    this._userDaoPurchase = DynamoDBPurchaseHistoryDao(this._urlPurchase);
    return await this._userDaoPurchase.getUsersPurchaseHistory();
  }

  Future<String> postUsersPurchase(
      PurchaseHistoryDto purchaseHistoryDto) async {
    this._urlServicePurchase = UrlService(
      "https://3nmrf0dxv8.execute-api.us-east-1.amazonaws.com/prod",
      "/purchase",
    );
    this._urlPurchase = this._urlServicePurchase.createUrl();
    this._userDaoPurchase = DynamoDBPurchaseHistoryDao(this._urlPurchase);
    return await this._userDaoPurchase.postUsersPurchase(purchaseHistoryDto);
  }
}

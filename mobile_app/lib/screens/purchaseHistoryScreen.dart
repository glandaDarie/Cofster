import 'package:flutter/material.dart';
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:coffee_orderer/data_transfer/PurchaseHistoryDto.dart'
    show PurchaseHistoryDto;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/displayContentCards.dart'
    show displayContentCards;

class PurchaseHistoryPage extends StatefulWidget {
  final PurchaseHistoryController purchaseHistoryController;

  const PurchaseHistoryPage({@required this.purchaseHistoryController});

  @override
  State<PurchaseHistoryPage> createState() =>
      _ProfilePhotoPageState(purchaseHistoryController);
}

class _ProfilePhotoPageState extends State<PurchaseHistoryPage> {
  PurchaseHistoryController _purchaseHistoryController;

  _ProfilePhotoPageState(PurchaseHistoryController purchaseHistoryController) {
    this._purchaseHistoryController = purchaseHistoryController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "       Order history",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: Colors.brown.shade700,
        ),
        body: FutureBuilder<List<PurchaseHistoryDto>>(future: () async {
          String email =
              await LoggedInService.getSharedPreferenceValue("<username>");
          return await this
              ._purchaseHistoryController
              .getUsersPurchaseHistory(email);
        }(), builder: (BuildContext context,
            AsyncSnapshot<List<PurchaseHistoryDto>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Colors.brown, backgroundColor: Colors.white));
          } else if (snapshot.hasError) {
            return Text("Error occured: ${snapshot.error}");
          } else {
            List<PurchaseHistoryDto> purchaseHistoryInformation = snapshot.data;
            return ListView(
              children: purchaseHistoryInformation
                  .map((PurchaseHistoryDto purchaseInformation) =>
                      displayContentCards(purchaseInformation))
                  .toList(),
            );
          }
        }));
  }
}

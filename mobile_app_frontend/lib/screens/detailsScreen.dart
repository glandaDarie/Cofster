import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_orderer/controllers/DrinksInformationController.dart'
    show DrinksInformationController;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:coffee_orderer/controllers/IngredientController.dart'
    show IngredientController;
import 'package:coffee_orderer/controllers/RatingController.dart'
    show RatingController;
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/components/detailsScreen/firebaseOrderAnimatedList.dart'
    show FirebaseOrderAnimatedList;
import 'package:firebase_database/firebase_database.dart' show FirebaseDatabase;
import 'package:coffee_orderer/providers/orderIDProvider.dart'
    show OrderIDProvider;
import 'package:coffee_orderer/utils/informationLoaders.dart'
    show InformationLoaders;
import 'package:coffee_orderer/components/detailsScreen/detailsScreenBody.dart'
    show DetailsScreenBody;
import 'package:coffee_orderer/providers/dialogFormularTimerSingletonProvider.dart'
    show DialogFormularTimerSingletonProvider;
import 'package:coffee_orderer/screens/llmUpdaterFormularScreen.dart'
    show LLMUpdaterFormularPage;
import 'package:coffee_orderer/utils/llmFormularPopup.dart'
    show LlmFormularPopup;
import 'package:coffee_orderer/utils/constants.dart'
    show NUMBER_FORMULAR_CONSUMERS;

class DetailsPage extends StatefulWidget {
  final bool isGift;
  final Future<void> Function({String sharedPreferenceKey}) onSetDialogFormular;
  final BuildContext context;

  const DetailsPage({
    Key key,
    @required this.isGift,
    @required this.onSetDialogFormular,
    this.context = null,
  }) : super(key: key);

  @override
  _DetailsPageState createState() =>
      _DetailsPageState(isGift, onSetDialogFormular, context);
}

class _DetailsPageState extends State<DetailsPage> {
  bool hotSelected;
  ValueNotifier<bool> hotSelectedNotifier;
  ValueNotifier<bool> placedOrderNotifier;
  ValueNotifier<double> ratingBarNotifier;
  DrinksInformationController drinksInformationController;
  IngredientController ingredientsController;
  RatingController ratingController;
  List<String> _ingredients;
  String _preparationTime;
  List<String> _nutritionInfo;
  PaymentService _paymentService;
  PurchaseHistoryController _purchaseHistoryController;
  ValueNotifier<bool> _isGiftValueNotifier;
  ValueNotifier<bool> _microtaskNotExecutedNotifier;
  bool _isGift;
  Future<void> Function({String sharedPreferenceKey}) onSetDialogFormular;
  BuildContext _context;

  _DetailsPageState(
    bool isGift,
    Future<void> Function({String sharedPreferenceKey})
        onSetDialogFormular, // the callback is either null or it exists
    BuildContext context,
  ) {
    this.hotSelectedNotifier = ValueNotifier<bool>(false);
    this.placedOrderNotifier = ValueNotifier<bool>(false);
    this.ratingBarNotifier = ValueNotifier<double>(0.0);
    this.drinksInformationController = DrinksInformationController();
    this.ingredientsController = IngredientController();
    this.ratingController = RatingController();
    this._ingredients = [];
    this._preparationTime = null;
    this._nutritionInfo = [];
    this._purchaseHistoryController = PurchaseHistoryController();
    this._isGiftValueNotifier = ValueNotifier<bool>(isGift);
    this._isGift = isGift;
    this._microtaskNotExecutedNotifier = ValueNotifier<bool>(true);
    this.onSetDialogFormular = onSetDialogFormular;
    this._context = context;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String orderID = context.watch<OrderIDProvider>().orderID;
    this._paymentService = PaymentService(context);
    return Scaffold(
      body: body(orderID: orderID),
    );
  }

  Widget body({@required final String orderID}) {
    return FutureBuilder<dynamic>(
      future: InformationLoaders.getCoffeeCardInformationFromPreviousScreen(
          "cardCoffeeName"),
      builder: (BuildContext context,
          AsyncSnapshot<dynamic> snapshotPreviousScreenData) {
        if (snapshotPreviousScreenData.connectionState ==
            ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.brown,
              backgroundColor: Colors.white,
            ),
          );
        } else if (snapshotPreviousScreenData.hasError) {
          return Center(
            child: Text(
                "Error from snapshotPreviousScreenData: ${snapshotPreviousScreenData.error}"),
          );
        } else if (snapshotPreviousScreenData.hasData) {
          String coffeeName = snapshotPreviousScreenData.data;
          Function contentBodyCallback = () => DetailsScreenBody(
                previousContext: this._context,
                drinksInformationController: this.drinksInformationController,
                coffeeName: coffeeName.replaceAll(" ", ""),
                ingredients: this._ingredients,
                preparationTime: this._preparationTime,
                nutritionInfo: this._nutritionInfo,
                placedOrderNotifier: this.placedOrderNotifier,
                ratingBarNotifier: this.ratingBarNotifier,
                ingredientsController: this.ingredientsController,
                isGiftValueNotifier: this._isGiftValueNotifier,
                microtaskNotExecutedNotifier:
                    this._microtaskNotExecutedNotifier,
                paymentService: this._paymentService,
                purchaseHistoryController: this._purchaseHistoryController,
                ratingController: this.ratingController,
              );
          return orderID != null
              ? Stack(
                  children: [
                    contentBodyCallback(),
                    FirebaseOrderAnimatedList(
                      FirebaseDatabase.instance
                          .ref()
                          .child("Orders")
                          .child(orderID),
                      context,
                      deleteGift: _isGift,
                      giftName: coffeeName,
                    )
                  ],
                )
              : contentBodyCallback();
        } else {
          return Center(
            child: Text("No data available"),
          );
        }
      },
    );
  }
}

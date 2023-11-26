import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/paths.dart' show Paths;
import 'package:coffee_orderer/screens/authScreen.dart' show AuthPage;
import 'package:coffee_orderer/services/inviteAFriendService.dart'
    show InvitieAFriendService;
import 'package:coffee_orderer/utils/catchPhrases.dart' show CatchPhrases;
import 'package:coffee_orderer/screens/orderScreen.dart' show OrderPage;
import 'package:coffee_orderer/screens/helpAndSupportScreen.dart'
    show HelpAndSupportPage;
import 'package:coffee_orderer/screens/purchaseHistoryScreen.dart'
    show PurchaseHistoryPage;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:coffee_orderer/utils/localUserInformation.dart'
    show loadUserInformationFromCache, fromStringCachetoMapCache;
import 'package:coffee_orderer/components/profileInformationScreen/deleteUserDialog.dart'
    show showDeleteConfirmationDialog;

class ProfileCardService {
  static String ordersInProgress({@required BuildContext context}) {
    String errorMsg = null;
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderPage(),
        ),
      );
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  static String purchaseHistory({@required BuildContext context}) {
    String errorMsg = null;
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PurchaseHistoryPage(
            purchaseHistoryController: PurchaseHistoryController(),
          ),
        ),
      );
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  static String helpAndSupport({@required BuildContext context}) {
    String errorMsg = null;
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => HelpAndSupportPage(),
        ),
      );
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  static Future<String> inviteAFriend({@required BuildContext context}) async {
    String errorMsg = null;
    try {
      await InvitieAFriendService.displayCofsterLocationMap(
          Paths.PATH_TO_COFSTER_LOCATION,
          catchPhrase: CatchPhrases.CATCH_PHRASE_COFSTER);
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  static Future<String> singOut({@required BuildContext context}) async {
    String errorMsg = null;
    try {
      final String loggingStatusErrorMsg =
          await LoggedInService.changeSharedPreferenceLoggingStatus();
      if (loggingStatusErrorMsg != null) {
        errorMsg = loggingStatusErrorMsg.toString();
        return errorMsg;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AuthPage(),
        ),
      );
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  // TODO
  // should appear a popup diagram
  // here should be the backend code to delete the account user from the database using AWS lambda
  static Future<String> deleteAccount({@required BuildContext context}) async {
    String errorMsg = null;
    try {
      final String cacheStr = await loadUserInformationFromCache();
      final Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
      final String confirmationDialogMsg = await showDeleteConfirmationDialog(
        context: context,
        deleteFn: (BuildContext context) async {
          final String errorMsg = await singOut(context: context);
          assert(
            errorMsg == null,
            "Error on Sign Out button: ${errorMsg}",
          );
        },
        cancelFn: (BuildContext context) {
          Navigator.of(context).pop();
        },
      );
      if (confirmationDialogMsg != null) {
        errorMsg = confirmationDialogMsg.toString();
      }
      print("cached data: ${cache}");
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }
}

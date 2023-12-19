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
import 'package:coffee_orderer/controllers/UserController.dart'
    show UserController;
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class ProfileCardService {
  static String ordersInProgress({@required BuildContext context}) {
    String errorMsg = null;
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (final BuildContext context) => OrderPage(),
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
          builder: (final BuildContext context) => PurchaseHistoryPage(
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
          builder: (final BuildContext context) => HelpAndSupportPage(),
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
          builder: (final BuildContext context) => AuthPage(),
        ),
      );
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }

  static Future<String> deleteAccount({@required BuildContext context}) async {
    String errorMsg = null;
    try {
      final String confirmationDialogMsg = await showDeleteConfirmationDialog(
        context: context,
        deleteFn: (final BuildContext context) async {
          final String cacheStr = await loadUserInformationFromCache();
          final Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
          final UserController userController = UserController();
          String username = null;
          try {
            username =
                await LoggedInService.getSharedPreferenceValue("<username>");
          } catch (error) {
            errorMsg = error.toString();
            return errorMsg;
          }
          final String name = cache["name"];
          final Map<String, String> content = {
            "name": name,
            "username": username,
          };
          final String deleteUserErrrorMsg =
              await userController.deleteUserFromCredentials(content);
          if (deleteUserErrrorMsg != null) {
            errorMsg = deleteUserErrrorMsg.toString();
          }

          ToastUtils.showToast("Deleted account of user: ${name} succesfully!");
          LOGGER.i("Deleted account of user: ${name} succesfully!");

          final String errorMsgSignOut = await singOut(context: context);
          assert(
            errorMsgSignOut == null,
            "Error on Sign Out button: ${errorMsgSignOut}",
          );
        },
        cancelFn: (final BuildContext context) {
          Navigator.of(context).pop();
        },
      );
      if (confirmationDialogMsg != null) {
        errorMsg = confirmationDialogMsg.toString();
      }
    } catch (error) {
      errorMsg = error.toString();
    }
    return errorMsg;
  }
}

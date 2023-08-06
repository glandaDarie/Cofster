import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  BuildContext _contextPaymentPage;
  Map<String, dynamic> _paymentIntent;
  PaymentService(BuildContext contextPaymentPage) {
    this._contextPaymentPage = contextPaymentPage;
    this._paymentIntent = null;
  }

  Future<String> makePayment(BuildContext contextPopupDrinkChooser,
      String amount, String coffeeName, String currency) async {
    String msg = "success";
    try {
      await dotenv.load(fileName: "assets/.env");
      Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY'];
    } catch (error) {
      return "Error when trying to load the credentials: $error";
    }
    try {
      this._paymentIntent = await this._createPaymentIntent(amount, currency);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      this._paymentIntent['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: "Ikay"))
          .then((PaymentSheetPaymentOption value) {});
      Navigator.of(contextPopupDrinkChooser).pop();
      String errorResponseDisplayPaymentSheet =
          await this._displayPaymentSheet(amount, coffeeName);
      if (errorResponseDisplayPaymentSheet != null) {
        return "Error when trying to display the payment sheet: $errorResponseDisplayPaymentSheet";
      }
    } catch (error) {
      return "Error when trying to make the payment: ${error}";
    }
    return msg;
  }

  Future<dynamic> _createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer ${dotenv.env['SECRET_KEY']}",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<String> _displayPaymentSheet(String amount, String coffeeName) async {
    String error_msg = null;
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((PaymentSheetPaymentOption value) {
        showDialog(
            context: _contextPaymentPage,
            builder: (BuildContext _) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                          "Payment has been done successfully. Payed: ${amount} for ${coffeeName}"),
                    ],
                  ),
                ));
        this._paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      error_msg = "$e";
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      error_msg = "$e";
    }
    return error_msg;
  }
}

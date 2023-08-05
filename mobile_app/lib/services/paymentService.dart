import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  BuildContext _context;
  Map<String, dynamic> _paymentIntent;
  PaymentService(BuildContext context) {
    this._context = context;
    this._paymentIntent = null;
  }

  Future<void> makePayment(
      String amount, String coffeeName, String currency) async {
    String error_msg =
        "Payment has been done successfully. Payed: ${amount} for ${coffeeName}";
    await dotenv.load(fileName: "assets/.env");
    Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY'];
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
      String errorResponseDisplayPaymentSheet =
          await this._displayPaymentSheet();
      if (errorResponseDisplayPaymentSheet != null) {
        return "Can't display payment sheet: $errorResponseDisplayPaymentSheet";
      }
    } catch (error) {
      return "Error when trying to pay: ${error}";
    }
    return error_msg;
  }

  Future<dynamic> _createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
      };
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer ${dotenv.env['SECRET_KEY']}",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<String> _displayPaymentSheet() async {
    String error_msg = null;
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((PaymentSheetPaymentOption value) {
        showDialog(
            context: _context,
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
                      Text("Payment Successful!"),
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

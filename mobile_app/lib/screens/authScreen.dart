import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/profilePhotoScreen.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthController _authController;
  String _name;

  _AuthPageState() {
    this._authController = AuthController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: FlutterLogin(
          additionalSignupFields: [
            UserFormField(
                keyName: "1",
                displayName: "Name",
                icon: Icon(Icons.person),
                fieldValidator: this._authController.validateNameSurname,
                userType: LoginUserType.name),
            UserFormField(
                keyName: "2",
                displayName: "Surname",
                icon: Icon(Icons.person),
                fieldValidator: this._authController.validateNameSurname,
                userType: LoginUserType.name),
          ],
          scrollable: true,
          logo: AssetImage("assets/images/cold_coffee.jpg"),
          theme: LoginTheme(
              primaryColor: Color.fromARGB(255, 140, 111, 81),
              accentColor: Color.fromARGB(255, 232, 233, 236)),
          onLogin: (LoginData data) async {
            String loggingStatusResponse =
                await LoggedInService.changeSharedPreferenceLoggingStatus();
            if (loggingStatusResponse != null) {
              Fluttertoast.showToast(
                  msg:
                      "Problems when changing the logging status: ${loggingStatusResponse}",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Color.fromARGB(255, 102, 33, 12),
                  textColor: Color.fromARGB(255, 220, 217, 216),
                  fontSize: 16);
              return null;
            }
            const String usernameKey = "<username>";
            String setUsernameStatusResponse =
                await LoggedInService.setSharedPreferenceValue(usernameKey,
                    value: data.name);
            if (setUsernameStatusResponse != null) {
              Fluttertoast.showToast(
                msg: "Problems when setting the key: "
                    "${usernameKey.substring(1, usernameKey.length - 1)} to : ${data.name}, "
                    "error: ${setUsernameStatusResponse}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Color.fromARGB(255, 102, 33, 12),
                textColor: Color.fromARGB(255, 220, 217, 216),
                fontSize: 16,
              );
              return null;
            }
            return this._authController.authUser(data);
          },
          onSignup: (SignupData signupData) async {
            // comment for easier debugging in the code
            // String uniqueUsernameResponse =
            //     await this._authController.usernameUniqueOnSingup(signupData.name);
            // if (uniqueUsernameResponse != null) {
            //   return uniqueUsernameResponse;
            // }
            setState(() {
              _name = signupData.additionalSignupData["1"];
            });
            String surname = signupData.additionalSignupData["2"];
            String response = await this
                ._authController
                .signupUser(signupData, _name, surname);
            storeUserInformationInCache({"code": response});
            return null;
          },
          userValidator: this._authController.validateUsername,
          passwordValidator: this._authController.validatePassword,
          onSubmitAnimationCompleted: () async {
            String errorMsg =
                await this._authController.loginCompletedSuccessfully();
            if (errorMsg != null) {
              Fluttertoast.showToast(
                  msg:
                      "Exception when trying to fetch the credentials or name: ${errorMsg}",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Color.fromARGB(255, 102, 33, 12),
                  textColor: Color.fromARGB(255, 220, 217, 216),
                  fontSize: 16);
              return;
            }
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          },
          onConfirmSignup: (String verificationCode, LoginData data) async {
            String response = await this
                ._authController
                .compareVerificationCode(verificationCode);
            if (response != null) {
              return "Code is not written correctly";
            }
            if (_name == null) {
              return "Name is not written correctly";
            }
            await this._authController.singupCompletedSuccessfully(_name, data);
            String loggingStatusResponse =
                await LoggedInService.changeSharedPreferenceLoggingStatus();
            if (loggingStatusResponse != null) {
              Fluttertoast.showToast(
                  msg:
                      "Problems when changing the logging status: ${loggingStatusResponse}",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Color.fromARGB(255, 102, 33, 12),
                  textColor: Color.fromARGB(255, 220, 217, 216),
                  fontSize: 16);
              return null;
            }
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfilePhotoPage()));
            return null;
          },
          onResendCode: (SignupData signupData) async {
            String response =
                await this._authController.sendEmail(signupData.name);
            storeUserInformationInCache({"code": response});
            return null;
          },
          onRecoverPassword: this._authController.recoverPassword,
        ),
      ),
    );
  }
}

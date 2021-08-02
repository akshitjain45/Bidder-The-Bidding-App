import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/defaultButton.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextController = TextEditingController();

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Forgot your password"),
          content: Text("An email has been sent to reset your password"),
          actions: <Widget>[
            TextButton(
              child: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//reset password function

  void reset() async {
    try {
      if (!_formKey.currentState!.validate()) {
        throw 'Please enter correct details';
      }
      await authService.passwordReset(emailTextController.text);
      _showPasswordEmailSentDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Please enter your email and we will send \nyou a link to return to your account",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kEmailNullError;
                          } else if (!emailValidatorRegExp.hasMatch(value)) {
                            return kInvalidEmailError;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.mail),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      DefaultButton(
                        text: "Continue",
                        press: reset,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, Routes.signUp),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

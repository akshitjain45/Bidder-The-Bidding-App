import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/screens/home/homepage.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/services/firebase_messaging.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/keyboard.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();

  _navigate(t) async {
    //for notifications
    String notificationToken = (await FirebaseMessage().getToken())!;
    UserDBServices().updateNotificationToken(
        Provider.of<AppUser>(context, listen: false).id!, notificationToken);
    if (t != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);
    }
  }

  //! ***************************************  GOOGLE SIGN IN  ******************************
  Future signInWithGoogle() async {
    try {
      var user = await authService.googleSign();
      _navigate(user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
      ));
    }
  }

//! ****************************    the process of sign in through email and password     ****************************
  Future loginuser() async {
    try {
      var user = await authService.loginUser(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (user != null) _navigate(user);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Could not Sign In"),
                content: Text('${e is VerificationError ? e.message : e}'),
                actions: <Widget>[
                  TextButton(
                      child: Text("Dismiss"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in with your email and password  \nor continue with Google",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildEmailFormField(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildPasswordFormField(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, Routes.forgotPwd),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        DefaultButton(
                          text: "Continue",
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);
                              try {
                                await loginuser();
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('$e'),
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  GestureDetector(
                    child: SvgPicture.asset(
                      "assets/icons/google-icon.svg",
                      width: 45,
                    ),
                    onTap: signInWithGoogle,
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
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.signUp),
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
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: obscurePassword,
      controller: passwordTextController,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
        prefixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
    );
  }
}

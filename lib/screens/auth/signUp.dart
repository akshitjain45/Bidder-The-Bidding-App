import 'package:bidding_app/screens/auth/login.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/defaultButton.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  TextEditingController confirmPasswordTextController =
      new TextEditingController();

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //! ********************************** return object of type Dialog  **************************
        return AlertDialog(
          title: Text("Verify your account"),
          content: Text(
              "Please verify your email before we start your journey with Bidder! The link has been sent to your email."),
          actions: <Widget>[
            TextButton(
              child: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    try {
      if (!_formKey.currentState!.validate()) {
        throw 'Please enter correct information';
      }
      if (passwordTextController.text != confirmPasswordTextController.text) {
        throw 'Confirm password and password do not match';
      }
      await authService.createUser(
          email: emailTextController.text,
          password: passwordTextController.text);
      _showVerifyEmailSentDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign Up"),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text("Register Account", style: headingStyle),
                  Text(
                    "Complete your details or continue \nwith social media",
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
                        buildConfirmPassFormField(),
                        SizedBox(height: getProportionateScreenHeight(40)),
                        DefaultButton(
                          text: "Continue",
                          press: _register,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: obscureConfirmPassword,
      controller: confirmPasswordTextController,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if ((passwordTextController.text != value)) {
          return kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(
            obscureConfirmPassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
          onPressed: () {
            setState(() {
              obscureConfirmPassword = !obscureConfirmPassword;
            });
          },
        ),
        prefixIcon: Icon(Icons.lock),
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

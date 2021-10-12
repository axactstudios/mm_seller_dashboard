import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/components/custom_suffix_icon.dart';
import 'package:mm_seller_dashboard/components/default_button.dart';
import 'package:mm_seller_dashboard/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:mm_seller_dashboard/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:mm_seller_dashboard/screens/forgot_password/forgot_password_screen.dart';
import 'package:mm_seller_dashboard/screens/my_orders/my_orders_screen.dart';
import 'package:mm_seller_dashboard/screens/my_products/my_products_screen.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';
import 'package:mm_seller_dashboard/wrappers/authentication_wrapper.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  // @override
  // void dispose() {
  //   emailFieldController.dispose();
  //   passwordFieldController.dispose();
  //   super.dispose();
  // }

  bool perform = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildForgotPasswordWidget(context),
          SizedBox(height: getProportionateScreenHeight(15)),
          DefaultButton(
            text: "Sign in",
            press: signInButtonCallback,
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Platform.isIOS
              ? SizedBox(height: getProportionateScreenHeight(30))
              : Container(),
          // SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }

  Row buildForgotPasswordWidget(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordScreen(),
                ));
          },
          child: Text(
            "Forgot Password",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallback() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      final AuthenticationService authService = AuthenticationService();
      bool signInStatus = false;
      String snackbarMessage;
      try {
        final signInFuture = authService.signIn(
          email: emailFieldController.text.trim(),
          password: passwordFieldController.text.trim(),
        );
        signInFuture.then((value) => signInStatus = value);
        signInStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signInFuture,
              message: Text("Signing in to account"),
            );
          },
        );
        if (signInStatus == true) {
          snackbarMessage = "Signed In Successfully";

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tabbar(screens: [
                MyProductsScreen(),
                MyOrdersScreen(),
              ]),
            ),
          );
        } else {
          throw FirebaseSignInAuthUnknownReasonFailure();
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}

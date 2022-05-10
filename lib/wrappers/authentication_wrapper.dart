import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:mm_seller_dashboard/screens/my_orders/my_orders_screen.dart';
import 'package:mm_seller_dashboard/screens/my_products/my_products_screen.dart';
import 'package:mm_seller_dashboard/screens/sign_in/sign_in_screen.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';

import '../constants.dart';

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class AuthenticationWrapper extends StatefulWidget {
  static const String routeName = "/authentication_wrapper";

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  String localStatus = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _message = '';

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('seller');

    _firebaseMessaging.getToken().then((token) => print(token));
  }

  void initState() {
    super.initState();
    getLocalAuthStatus();

    _registerOnFirebase();
    getMessage();
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('received message');
      setState(() => _message = message["notification"]["body"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["body"]);
    });
  }

  Future<String> getLocalAuthStatus() async {
    localStatus = await AuthenticationService().getLocalAuthStatus();
    return localStatus;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Tabbar(screens: [
            MyProductsScreen(),
            MyOrdersScreen(),
          ]);
        } else {
          if (localStatus == 'LoggedIn')
            return Tabbar(screens: [
              MyProductsScreen(),
              MyOrdersScreen(),
            ]);
          else
            return SignInScreen();
        }
      },
    );
  }
}

class Tabbar extends StatefulWidget {
  Tabbar({this.screens});

  static const Tag = "Tabbar";
  final List<Widget> screens;
  @override
  State<StatefulWidget> createState() {
    return _TabbarState();
  }
}

class _TabbarState extends State<Tabbar> {
  int _currentIndex = 0;
  Widget currentScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              EvaIcons.home,
              color: _currentIndex == 0 ? kPrimaryColor : kPurpleColor,
            ),
            title: _currentIndex == 0
                ? Text(
                    'Home',
                    style: TextStyle(color: kPrimaryColor),
                  )
                : Text(''),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              EvaIcons.giftOutline,
              color: _currentIndex == 1 ? kPrimaryColor : kPurpleColor,
            ),
            title: _currentIndex == 1
                ? Text(
                    'Orders',
                    style: TextStyle(color: kPrimaryColor),
                  )
                : Text(''),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

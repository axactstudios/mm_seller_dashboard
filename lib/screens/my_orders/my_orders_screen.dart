import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import 'components/body.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Orders",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
              fontSize: 22),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.headset, color: kPrimaryColor),
              onPressed: () {
                launch('https://wa.me/919354807154?text=Support!');
              }),
        ],
      ),
      body: Body(),
    );
  }
}

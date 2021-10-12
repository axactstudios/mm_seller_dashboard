import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mm_seller_dashboard/screens/search_result/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import 'components/body.dart';

class MyProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Inventory",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
              fontSize: 22),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                EvaIcons.search,
                color: kPrimaryColor,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.headset, color: kPrimaryColor),
              onPressed: () {
                launch('https://wa.me/919027553376?text=Support!');
              }),
        ],
      ),
      body: Body(),
      //body: Body(),
    );
  }
}

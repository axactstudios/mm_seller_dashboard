import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mm_seller_dashboard/models/Address.dart';
import 'package:mm_seller_dashboard/models/Order.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import 'components/body.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final List<Widget> orderedProducts;
  final Address address;

  const OrderDetailScreen(
      {Key key,
      @required this.order,
      @required this.orderedProducts,
      @required this.address})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Order Details",
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
                launch('https://wa.me/919027553376?text=Support!');
              }),
        ],
      ),
      body: Body(
        order: order,
        orderedProducts: orderedProducts,
        address: address,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mm_seller_dashboard/models/Address.dart';
import 'package:mm_seller_dashboard/models/Order.dart';
import 'package:mm_seller_dashboard/screens/product_details/product_details_screen.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

//TODO: Make code modular and convert to stateless page

class Body extends StatefulWidget {
  final Order order;
  final List<Widget> orderedProducts;
  final Address address;

  const Body(
      {Key key,
      @required this.order,
      @required this.orderedProducts,
      @required this.address})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String statusText = '';
  String animationAsset = '';

  @override
  void initState() {
    if (widget.order.status == 'Pending') {
      statusText = 'Your order has been placed';
      animationAsset = 'assets/images/order_packed.json';
    } else if (widget.order.status == 'Cancelled') {
      animationAsset = 'assets/images/order_cancel.json';
      statusText = 'Your order has been cancelled';
    } else {
      animationAsset = 'assets/images/order_delivered.json';
      statusText = 'Your order has been delivered';
    }
    getAddressFromID();
    setState(() {});
    super.initState();
  }

  Address add = new Address();
  getAddressFromID() async {
    // print(widget.order.address);
    // print(widget.order.userid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenHeight,
        child: ListView(
          children: [
            Container(
                height: 300,
                width: SizeConfig.screenWidth,
                child: Center(
                  child: Stack(
                    children: [
                      Lottie.asset(animationAsset),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "    $statusText",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kTextColor.withOpacity(0.12),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Summary',
                            style: categoryBlockHeadingStyle,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Customer Name:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: '${widget.address.receiver}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Customer Address:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${widget.address.addresLine1},${widget.address.addressLine2},${widget.address.city},${widget.address.district},${widget.address.landmark}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Customer Phone Number:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: '${widget.address.phone}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Ordered ID:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: '${widget.order.orderid}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Ordered on:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${widget.order.timestamp.toDate().day}-${widget.order.timestamp.toDate().month}-${widget.order.timestamp.toDate().year}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.order.status == 'Pending'
                            ? Text.rich(
                                TextSpan(
                                  text: "Expected Delivery:  ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${widget.order.timestamp.toDate().day + 4}-${widget.order.timestamp.toDate().month}-${widget.order.timestamp.toDate().year}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Text.rich(
                          TextSpan(
                            text: "Status:  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: widget.order.status == 'Pending'
                                    ? 'Order Placed'
                                    : '${widget.order.status}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: kTextColor.withOpacity(0.15),
                        ),
                      ),
                    ),
                    child: Column(
                      children: widget.orderedProducts,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: FlatButton(
                      color: kPrimaryColor,
                      child: Text(
                        "Order Total - ${widget.order.amount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                'Seller Support',
                style: categoryBlockHeadingStyle,
              ),
            ),
            Center(
                child: Container(
                    height: 150,
                    child: Lottie.asset(
                        'assets/images/18185-customer-support.json'))),
            Center(
              child: Text(
                'For any queries related to return\nor replacement of order.',
                textAlign: TextAlign.center,
              ),
            ),
            InkWell(
              onTap: () {
                launch('tel:+91 9161961471');
              },
              child: Center(child: Text('Call or WhatsApp at +91 9354807154')),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {});
  }
}

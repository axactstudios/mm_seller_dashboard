import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/components/product_actions_section.dart';
import 'package:mm_seller_dashboard/screens/product_details/components/product_images.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../product_details_screen.dart';
import 'dynamic_link_controller.dart';

//TODO: Make code modular and convert to stateless page

class Body extends StatefulWidget {
  final String productId;
  final String productName;

  const Body({
    Key key,
    @required this.productId,
    @required this.productName,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final DynamicLinkController _dynamicLinkController =
      Get.put(DynamicLinkController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data;
                return Column(
                  children: [
                    SizedBox(
                        height: 520,
                        child: ProductImages(
                          product: product,
                          controller: _dynamicLinkController,
                        )),
                    // Container(
                    //   color: Colors.grey,
                    //   height: 1,
                    //   width: SizeConfig.screenWidth,
                    // ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    ProductActionsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    // ProductReviewsSection(product: product),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Image.network(
                          "https://img4.urbanic.com/f6587ab6cb0740dc9c50adb26066a176"),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),

                    SizedBox(height: getProportionateScreenHeight(100)),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
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

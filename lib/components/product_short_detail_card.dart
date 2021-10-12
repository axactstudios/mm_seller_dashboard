import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/components/variants_section.dart';
import 'package:mm_seller_dashboard/screens/product_details/product_details_screen.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/data_streams/data_stream.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';

import '../constants.dart';
import '../size_config.dart';
import '../utils.dart';

class ProductShortDetailCard extends StatefulWidget {
  final String productId;
  final String quantity;
  final String color;
  final bool checkout;
  final String orderedQuantity;
  final DataStream stream;

  final String size;

  final VoidCallback onPressed;
  const ProductShortDetailCard(
      {Key key,
      @required this.productId,
      @required this.onPressed,
      @required this.color,
      @required this.checkout,
      @required this.size,
      @required this.quantity,
      @required this.orderedQuantity,
      this.stream})
      : super(key: key);

  @override
  _ProductShortDetailCardState createState() => _ProductShortDetailCardState();
}

class _ProductShortDetailCardState extends State<ProductShortDetailCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;

            return Row(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(100),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.65,
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: product.images.length > 0
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    imageUrl: product.images[0],
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Text("No Image"),
                        ),
                      ),
                      product.soldOut == true
                          ? Container(
                              width: getProportionateScreenWidth(100),
                              height: 150,
                              color: Colors.black.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  'Out Of Stock',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: getProportionateScreenWidth(145),
                            child: Text(
                              product.title,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          widget.size != null
                              ? Text(
                                  "Size: ${widget.size} | Color: ${widget.color}",
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                                text:
                                    "\₹${product.discountPrice.toStringAsFixed(2)}    ",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "\₹${product.originalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: kTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ]),
                          ),

                          // SizedBox(height: getProportionateScreenHeight(60))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
                widget.checkout != null
                    ? widget.checkout
                        ? Expanded(
                            flex: 1,
                            child: product.soldOut == true
                                ? InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      ProductDatabaseHelper()
                                          .changeProductStockStatus(
                                              product.id, product.soldOut);
                                      setState(() {});
                                    },
                                    child: Container(
                                        height: 150,
                                        width: 30,
                                        child: Icon(EvaIcons.eyeOff)))
                                : InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      ProductDatabaseHelper()
                                          .changeProductStockStatus(
                                              product.id, product.soldOut);
                                      setState(() {});
                                    },
                                    child: Container(
                                        height: 150,
                                        width: 30,
                                        child: Icon(EvaIcons.eyeOutline))),
                          )
                        : Container()
                    : Container()
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
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
    );
  }
}

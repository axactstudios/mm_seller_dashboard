import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/provider_models/ProductActions.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

import '../size_config.dart';
import '../utils.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String title;
  final GestureTapCallback press;
  const ProductCard({
    Key key,
    @required this.productId,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Product product = snapshot.data;
            return title == 'Explore All Products'
                ? product.top == true
                    ? buildProductCardItems(product, context)
                    : Container()
                : buildProductCardItems(product, context);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Center(child: CircularProgressIndicator()),
            );
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
    );
  }

  Card buildProductCardItems(Product product, BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 2,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            color: Colors.white,
            width: width * 0.285,
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: getProportionateScreenHeight(165),
                child: product.soldOut != true
                    ? CachedNetworkImage(
                        imageUrl: product.images[0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Stack(
                        children: [
                          Container(
                              height: getProportionateScreenHeight(165),
                              width: width * 0.285,
                              child: CachedNetworkImage(
                                imageUrl: product.images[0],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                          Container(
                            height: getProportionateScreenHeight(165),
                            width: width * 0.285,
                            color: Colors.black.withOpacity(0.2),
                            child: Center(
                                child: Text(
                              'Out Of Stock',
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  "${product.title}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kPrimaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "₹${product.discountPrice.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                "₹${product.originalPrice.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kTextColor.withOpacity(0.5),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            margin:
                EdgeInsets.only(top: height * 0, right: width * 0.2, left: 0),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(3))),
            height: height * 0.03,
            width: width * 0.1,
            alignment: Alignment.center,
            child: Text(
                ("${(((product.originalPrice - product.discountPrice) / product.originalPrice) * 100).toStringAsFixed(0)}%"),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
//      Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: [
//        Container(
//          width: SizeConfig.screenWidth * 0.35,
//          height: SizeConfig.screenWidth * 0.4,
//          child: Image.network(
//            product.images[0],
//            fit: BoxFit.contain,
//          ),
//        ),
//        SizedBox(height: 10),
//        Flexible(
//          flex: 2,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Flexible(
//                flex: 1,
//                child: Text(
//                  "${product.title}\n",
//                  style: TextStyle(
//                    color: kTextColor,
//                    fontSize: 14,
//                    fontWeight: FontWeight.bold,
//                  ),
//                  maxLines: 2,
//                  overflow: TextOverflow.ellipsis,
//                ),
//              ),
//              SizedBox(height: 5),
//              Container(
//                height: 43,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    Flexible(
//                      flex: 5,
//                      child: Text.rich(
//                        TextSpan(
//                          text: "\₹${product.discountPrice} ",
//                          style: TextStyle(
//                            color: kPrimaryColor,
//                            fontWeight: FontWeight.w700,
//                            fontSize: 17,
//                          ),
//                          children: [
//                            TextSpan(
//                              text: "\₹${product.originalPrice}",
//                              style: TextStyle(
//                                color: kTextColor,
//                                decoration: TextDecoration.lineThrough,
//                                fontWeight: FontWeight.normal,
//                                fontSize: 13,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                    Flexible(
//                      flex: 2,
//                      child: ChangeNotifierProvider(
//                          create: (context) => ProductActions(),
//                          child: FutureBuilder<Product>(
//                              future: ProductDatabaseHelper()
//                                  .getProductWithID(productId),
//                              builder: (context, snapshot) {
//                                return Consumer<ProductActions>(
//                                  builder: (context, productDetails, child) {
//                                    return InkWell(
//                                      onTap: () async {
//                                        bool allowed = AuthentificationService()
//                                            .currentUserVerified;
//                                        if (!allowed) {
//                                          final reverify =
//                                              await showConfirmationDialog(
//                                                  context,
//                                                  "You haven't verified your email address. This action is only allowed for verified users.",
//                                                  positiveResponse:
//                                                      "Resend verification email",
//                                                  negativeResponse: "Go back");
//                                          if (reverify) {
//                                            final future = AuthentificationService()
//                                                .sendVerificationEmailToCurrentUser();
//                                            await showDialog(
//                                              context: context,
//                                              builder: (context) {
//                                                return FutureProgressDialog(
//                                                  future,
//                                                  message: Text(
//                                                      "Resending verification email"),
//                                                );
//                                              },
//                                            );
//                                          }
//                                          return;
//                                        }
//                                        bool success = false;
//                                        final future = UserDatabaseHelper()
//                                            .switchProductFavouriteStatus(
//                                                product.id,
//                                                !productDetails
//                                                    .productFavStatus)
//                                            .then(
//                                          (status) {
//                                            success = status;
//                                          },
//                                        ).catchError(
//                                          (e) {
//                                            Logger().e(e.toString());
//                                            success = false;
//                                          },
//                                        );
//                                        await showDialog(
//                                          context: context,
//                                          builder: (context) {
//                                            return FutureProgressDialog(
//                                              future,
//                                              message: Text(
//                                                productDetails.productFavStatus
//                                                    ? "Removing from Favourites"
//                                                    : "Adding to Favourites",
//                                              ),
//                                            );
//                                          },
//                                        );
//                                        if (success) {
//                                          productDetails
//                                              .switchProductFavStatus();
//                                        }
//                                      },
//                                      child: Container(
//                                        child: productDetails.productFavStatus
//                                            ? Icon(
//                                                Icons.favorite,
//                                                color: kPrimaryColor,
//                                                size: 30,
//                                              )
//                                            : Icon(
//                                                Icons.favorite_outline,
//                                                color: kPrimaryColor,
//                                                size: 30,
//                                              ),
//                                      ),
//                                    );
//                                  },
//                                );
//                              })),
//                    )
//                    // Flexible(
//                    //   flex: 3,
//                    //   child: Stack(
//                    //     children: [
//                    //       SvgPicture.asset(
//                    //         "assets/icons/DiscountTag.svg",
//                    //         color: kPrimaryColor,
//                    //       ),
//                    //       Center(
//                    //         child: Text(
//                    //           "${product.calculatePercentageDiscount()}%\nOff",
//                    //           style: TextStyle(
//                    //             color: Colors.white,
//                    //             fontSize: 8,
//                    //             fontWeight: FontWeight.w900,
//                    //           ),
//                    //           textAlign: TextAlign.center,
//                    //         ),
//                    //       ),
//                    //     ],
//                    //   ),
//                    // ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ),
//      ],
//    );
  }
}

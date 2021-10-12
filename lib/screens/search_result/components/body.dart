
import 'package:flutter/material.dart';
import 'package:mm_seller_dashboard/components/nothingtoshow_container.dart';
import 'package:mm_seller_dashboard/components/product_card.dart';
import 'package:mm_seller_dashboard/screens/product_details/product_details_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class Body extends StatefulWidget {
  final String searchQuery;
  final List<String> searchResultProductsId;
  final String searchIn;

  const Body({
    Key key,
    @required this.searchQuery,
    @required this.searchResultProductsId,
    @required this.searchIn,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    //check
    // SearchedFilteredProductsStream searchedFilteredProductsStream=new SearchedFilteredProductsStream('', '', widget.searchQuery)
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
//                SizedBox(height: getProportionateScreenHeight(0)),
//                Text(
//                  "$searchQuery",
//                  style: headingStyle,
//                ),
//                Text.rich(
//                  TextSpan(
//                    text: " in ",
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontStyle: FontStyle.italic,
//                    ),
//                    children: [
//                      TextSpan(
//                        text: "$searchIn",
//                        style: TextStyle(
//                          decoration: TextDecoration.underline,
//                          fontWeight: FontWeight.normal,
//                          fontStyle: FontStyle.normal,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(height: getProportionateScreenHeight(30)),
                SizedBox(
                  // height: SizeConfig.screenHeight * 0.85,
                  child: buildProductsGrid(),
                ),
                //check
                // SizedBox(
                //   height: SizeConfig.screenHeight * 0.88,
                //   child: StreamBuilder<List<String>>(
                //     stream: widget.filteredProductsStream.stream,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         List<Product> products = snapshot.data;
                //         if (products.length == 0) {
                //           return Center(
                //             child: NothingToShowContainer(
                //               secondaryMessage:
                //               "No Products in ${widget.productType}",
                //             ),
                //           );
                //         }
                //
                //         return buildProductsGrid(products);
                //       } else if (snapshot.connectionState ==
                //           ConnectionState.waiting) {
                //         return Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       } else if (snapshot.hasError) {
                //         final error = snapshot.error;
                //         Logger().w(error.toString());
                //       }
                //       return Center(
                //         child: NothingToShowContainer(
                //           primaryMessage: "Something went wrong",
                //           secondaryMessage:
                //           "No Products in ${widget.productType}",
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductsGrid() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context) {
          if (widget.searchResultProductsId.length > 0) {
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 18,
              ),
              itemCount: widget.searchResultProductsId.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  productId: widget.searchResultProductsId[index],
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productId: widget.searchResultProductsId[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/search_no_found.svg",
              secondaryMessage: "Found 0 Products",
              primaryMessage: "Try another search keyword",
            ),
          );
        },
      ),
    );
  }
}

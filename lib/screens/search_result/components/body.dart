import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/components/nothingtoshow_container.dart';
import 'package:mm_seller_dashboard/components/product_card.dart';
import 'package:mm_seller_dashboard/components/product_short_detail_card.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/product_details_screen.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';

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
            child: SizedBox(
              height: SizeConfig.screenHeight * 0.85,
              child: buildProductsGrid(),
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
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.searchResultProductsId.length,
              itemBuilder: (context, index) {
                return buildProductsCard(widget.searchResultProductsId[index]);
              },
            );
            // return GridView.builder(
            //   shrinkWrap: true,
            //   physics: BouncingScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 0.7,
            //     crossAxisSpacing: 4,
            //     mainAxisSpacing: 18,
            //   ),
            //   itemCount: widget.searchResultProductsId.length,
            //   itemBuilder: (context, index) {
            //     return ProductCard(
            //       productId: widget.searchResultProductsId[index],
            //       press: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ProductDetailsScreen(
            //               productId: widget.searchResultProductsId[index],
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // );
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

  Widget buildProductsCard(String productId) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(productId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          return buildProductDismissible(product);
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
    );
  }

  Widget buildProductDismissible(Product product) {
    return ProductShortDetailCard(
      checkout: true,
      productId: product.id,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: product.id,
            ),
          ),
        );
      },
    );

    // return Dismissible(
    //   key: Key(product.id),
    //   direction: DismissDirection.horizontal,
    //   background: buildDismissibleSecondaryBackground(),
    //   secondaryBackground: buildDismissiblePrimaryBackground(),
    //   dismissThresholds: {
    //     DismissDirection.endToStart: 0.65,
    //     DismissDirection.startToEnd: 0.65,
    //   },
    //   child: ProductShortDetailCard(
    //     checkout: true,
    //     productId: product.id,
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => ProductDetailsScreen(
    //             productId: product.id,
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    //   confirmDismiss: (direction) async {
    //     if (direction == DismissDirection.startToEnd) {
    //       final confirmation = await showConfirmationDialog(
    //           context, "Are you sure to Delete Product?");
    //       if (confirmation) {
    //         for (int i = 0; i < product.images.length; i++) {
    //           String path =
    //               ProductDatabaseHelper().getPathForProductImage(product.id, i);
    //           final deletionFuture =
    //               FirestoreFilesAccess().deleteFileFromPath(path);
    //           await showDialog(
    //             context: context,
    //             builder: (context) {
    //               return FutureProgressDialog(
    //                 deletionFuture,
    //                 message: Text(
    //                     "Deleting Product Images ${i + 1}/${product.images.length}"),
    //               );
    //             },
    //           );
    //         }
    //
    //         bool productInfoDeleted = false;
    //         String snackbarMessage;
    //         try {
    //           final deleteProductFuture =
    //               ProductDatabaseHelper().deleteUserProduct(product.id);
    //           productInfoDeleted = await showDialog(
    //             context: context,
    //             builder: (context) {
    //               return FutureProgressDialog(
    //                 deleteProductFuture,
    //                 message: Text("Deleting Product"),
    //               );
    //             },
    //           );
    //           if (productInfoDeleted == true) {
    //             snackbarMessage = "Product deleted successfully";
    //           } else {
    //             throw "Coulnd't delete product, please retry";
    //           }
    //         } on FirebaseException catch (e) {
    //           Logger().w("Firebase Exception: $e");
    //           snackbarMessage = "Something went wrong";
    //         } catch (e) {
    //           Logger().w("Unknown Exception: $e");
    //           snackbarMessage = e.toString();
    //         } finally {
    //           Logger().i(snackbarMessage);
    //           Scaffold.of(context).showSnackBar(
    //             SnackBar(
    //               content: Text(snackbarMessage),
    //             ),
    //           );
    //         }
    //       }
    //       await refreshPage();
    //       return confirmation;
    //     } else if (direction == DismissDirection.endToStart) {
    //       final confirmation = await showConfirmationDialog(
    //           context, "Are you sure to Edit Product?");
    //       if (confirmation) {
    //         await Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => EditProductScreen(
    //               productToEdit: product,
    //             ),
    //           ),
    //         );
    //       }
    //       await refreshPage();
    //       return false;
    //     }
    //     return false;
    //   },
    //   onDismissed: (direction) async {
    //     await refreshPage();
    //   },
    // );
  }
}

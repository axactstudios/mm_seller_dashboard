import 'package:logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mm_seller_dashboard/screens/search_result/search_result_screen.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';

import '../constants.dart';
import '../size_config.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "Nothing to show",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            search('Printed Shirts', context);
          },
          child: SizedBox(
              height: SizeConfig.screenWidth * 0.435,
              child: Image.network(
                'https://img4.urbanic.com/a5f592ee016e4e61b3ee9e4ba557f301',
                width: SizeConfig.screenWidth,
              )),
        ),
        SizedBox(height: getProportionateScreenHeight(100)),
        SvgPicture.asset(
          iconPath,
          color: kTextColor,
          width: getProportionateScreenWidth(75),
        ),
        SizedBox(height: getProportionateScreenHeight(16)),
        Text(
          "$primaryMessage",
          style: TextStyle(
            color: kTextColor,
            fontSize: 15,
          ),
        ),
        Text(
          "$secondaryMessage",
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
      ],
    );
  }

  search(query, ctx) async {
    if (query.length <= 0) return;
    List<String> searchedProductsId;
    try {
      searchedProductsId =
          await ProductDatabaseHelper().searchInProducts(query.toLowerCase());
      if (searchedProductsId != null) {
        await Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(
              searchQuery: query,
              searchResultProductsId: searchedProductsId,
              searchIn: "All Products",
            ),
          ),
        );
      } else {
        throw "Couldn't perform search due to some unknown reason";
      }
    } catch (e) {
      final error = e.toString();
      Logger().e(error);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text("$error"),
        ),
      );
    }
  }
}

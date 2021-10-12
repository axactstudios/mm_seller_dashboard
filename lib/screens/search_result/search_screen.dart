import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/screens/search_result/search_result_screen.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../utils.dart';
import 'components/home_header.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(
              onSearchSubmitted: (value) async {
                final query = value.toString();
                if (query.length <= 0) return;
                List<String> searchedProductsId;
                try {
                  searchedProductsId = await ProductDatabaseHelper()
                      .searchInProducts(query.toLowerCase());
                  if (searchedProductsId != null) {
                    await Navigator.push(
                      context,
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
                  print(error);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$error"),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                'Top Searches',
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return topSearchItem(topSearchList[index], () async {
                    final query = topSearchList[index].toString();
                    if (query.length <= 0) return;
                    List<String> searchedProductsId;
                    try {
                      searchedProductsId = await ProductDatabaseHelper()
                          .searchInProducts(query.toLowerCase());
                      if (searchedProductsId != null) {
                        await Navigator.push(
                          context,
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
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$error"),
                        ),
                      );
                    }
                  });
                },
              ),
            ),
//            topSearchItem('Party Dresses')
          ],
        ),
      ),
    );
  }

  var topSearchList = [
    'Party Dresses',
    'Sarojini Market',
    'Tops',
    'Work From Home'
  ];

  Widget topSearchItem(title, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: getProportionateScreenWidth(130),
          decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  EvaIcons.trendingUp,
                  color: kPrimaryColor,
                )
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mm_seller_dashboard/models/Variant.dart';
import 'package:mm_seller_dashboard/screens/product_details/provider_models/ProductActions.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

Map<String, Variant> variantsSelected = {};

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final String productName;

  const ProductDetailsScreen({
    Key key,
    @required this.productId,
    @required this.productName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        body: Body(
          productId: productId,
          productName: productName,
        ),
      ),
    );
  }
}

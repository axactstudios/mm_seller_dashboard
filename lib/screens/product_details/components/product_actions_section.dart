import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/components/product_description.dart';
import 'package:mm_seller_dashboard/screens/product_details/provider_models/ProductActions.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import '../../../utils.dart';

class ProductActionsSection extends StatelessWidget {
  final Product product;

  const ProductActionsSection({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        Stack(
          children: [
            Container(
                color: Colors.white,
                child: ProductDescription(product: product)),
//            Align(
//              alignment: Alignment.topCenter,
//              child: buildFavouriteButton(),
//            ),
          ],
        ),
      ],
    );

    return column;
  }
}

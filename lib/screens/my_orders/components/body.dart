import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mm_seller_dashboard/components/nothingtoshow_container.dart';
import 'package:mm_seller_dashboard/components/product_short_detail_card.dart';
import 'package:mm_seller_dashboard/models/Order.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/order_detail/order_detail_screen.dart';
import 'package:mm_seller_dashboard/screens/product_details/product_details_screen.dart';
import 'package:mm_seller_dashboard/services/data_streams/orders_stream.dart';
import 'package:mm_seller_dashboard/services/database/orders_database_helper.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final OrdersStream ordersStream = OrdersStream();

  @override
  void initState() {
    super.initState();
    ordersStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    ordersStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: buildOrderedProductsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    ordersStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<Order>>(
      stream: ordersStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data;
          if (orders.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return FutureBuilder<List<Product>>(
                future:
                    OrdersDatabaseHelper().getOrderItems(orders[index].orderid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    return buildOrderedProductItem(
                        orderedProduct, orders[index]);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: kSecondaryColor,
                    ));
                  } else if (snapshot.hasError) {
                    final error = snapshot.error.toString();
                    Logger().e(error);
                  }
                  return Icon(
                    Icons.error,
                    size: 60,
                    color: kTextColor,
                  );
                },
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kSecondaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildOrderedProductItem(List<Product> orderedProducts, Order order) {
    List<Widget> products = [];
    for (int i = 0; i < orderedProducts.length; i++) {
      products.add(ProductShortDetailCard(
        productId: orderedProducts[i].id,
        color: order.color[i],
        size: order.size[i],
        quantity: '0',
        orderedQuantity: order.quantity[i].toString(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: orderedProducts[i].id,
              ),
            ),
          ).then((_) async {
            await refreshPage();
          });
        },
      ));
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetailScreen(order: order, orderedProducts: products),
          ),
        ).then((_) async {
          await refreshPage();
        });
      },
      child: Padding(
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
                  Text.rich(
                    TextSpan(
                      text: "Ordered ID:  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: '${order.orderid}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Status:  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: order.status == 'Pending'
                              ? 'Order Placed'
                              : '${order.status}',
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
                children: products,
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
                  "Order Total - ${order.amount}",
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
    );
  }
}

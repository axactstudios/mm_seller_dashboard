import 'package:mm_seller_dashboard/models/Order.dart';
import 'package:mm_seller_dashboard/services/database/orders_database_helper.dart';

import 'data_stream.dart';

class OrdersStream extends DataStream<List<Order>> {
  @override
  void reload() {
    final ordersFuture = OrdersDatabaseHelper().getOrdersOfCurrentUser();
    ordersFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}

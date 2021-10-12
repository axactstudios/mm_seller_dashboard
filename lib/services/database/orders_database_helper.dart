import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mm_seller_dashboard/models/Order.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';
import 'package:mm_seller_dashboard/services/database/product_database_helper.dart';
import 'package:mm_seller_dashboard/services/database/user_database_helper.dart';

class OrdersDatabaseHelper {
  static const String ORDERS_COLLECTION_NAME = "orders";
  static const String PRODUCTS = "products";
  static const String TIMESTAMP = "timestamp";
  // static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  // static const String PHONE_KEY = 'phone';
  // static const String DP_KEY = "display_picture";
  // static const String FAV_PRODUCTS_KEY = "favourite_products";

  OrdersDatabaseHelper._privateConstructor();
  static OrdersDatabaseHelper _instance =
      OrdersDatabaseHelper._privateConstructor();
  factory OrdersDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  //
  // Future<void> deleteCurrentUserData() async {
  //   final uid = AuthenticationService().currentUser.uid;
  //   final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
  //   final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
  //   final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
  //   final ordersCollectionRef =
  //       docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);
  //
  //   final cartDocs = await cartCollectionRef.get();
  //   for (final cartDoc in cartDocs.docs) {
  //     await cartCollectionRef.doc(cartDoc.id).delete();
  //   }
  //   final addressesDocs = await addressCollectionRef.get();
  //   for (final addressDoc in addressesDocs.docs) {
  //     await addressCollectionRef.doc(addressDoc.id).delete();
  //   }
  //   final ordersDoc = await ordersCollectionRef.get();
  //   for (final orderDoc in ordersDoc.docs) {
  //     await ordersCollectionRef.doc(orderDoc.id).delete();
  //   }
  //
  //   await docRef.delete();
  // }

  Future<bool> addOrderForCurrentUser(Order order, String key) async {
    String uid = AuthenticationService().currentUser.uid;
    final addressesCollectionReference =
        firestore.collection(ORDERS_COLLECTION_NAME);
    await addressesCollectionReference.doc(key).set(order.toMap());
    return true;
  }

  Future<List<Order>> getOrdersOfCurrentUser() async {
    String name = await UserDatabaseHelper().getCurrentUserName();
    final ordersCollectionReference =
        firestore.collection(ORDERS_COLLECTION_NAME);
    List<Order> userOrders = [];
    await ordersCollectionReference.get().then((value) async {
      for (var v in value.docs) {
        List productsOrdered = await v.data()['products_ordered'];
        for (var pr in productsOrdered) {
          Product p = await ProductDatabaseHelper().getProductWithID(pr);
          if (p.seller == name) userOrders.add(Order.fromMap(v.data()));
        }
      }
    });
    return userOrders;
  }

  Future<num> getNumberOfOrders() async {
    num userOrders = 0;
    if (AuthenticationService().currentUser != null) {
      String uid = AuthenticationService().currentUser.uid;
      final addressesCollectionReference =
          firestore.collection(ORDERS_COLLECTION_NAME);

      await addressesCollectionReference.get().then((value) {
        for (var v in value.docs) {
          if (v.data()['userid'] == uid) userOrders++;
        }
      });
    }

    return userOrders;
  }

  Future<num> getTotalDiscount() async {
    num userOrders = 0;
    if (AuthenticationService().currentUser != null) {
      String uid = AuthenticationService().currentUser.uid;
      final addressesCollectionReference =
          firestore.collection(ORDERS_COLLECTION_NAME);

      await addressesCollectionReference.get().then((value) {
        for (var v in value.docs) {
          if (v.data()['userid'] == uid)
            userOrders += Order.fromMap(v.data()).totalDiscount;
        }
      });
    }

    return userOrders;
  }

  Future<List<Product>> getOrderItems(String orderId) async {
    String uid = AuthenticationService().currentUser.uid;
    final orderDocument =
        await firestore.collection(ORDERS_COLLECTION_NAME).doc(orderId).get();
    List<Product> orderedProducts = [];

    for (var v in orderDocument.data()['products_ordered']) {
      orderedProducts.add(await ProductDatabaseHelper().getProductWithID(v));
    }

    return orderedProducts;
  }

//
// Future<bool> deleteAddressForCurrentUser(String id) async {
//   String uid = AuthenticationService().currentUser.uid;
//   final addressDocReference = firestore
//       .collection(USERS_COLLECTION_NAME)
//       .doc(uid)
//       .collection(ADDRESSES_COLLECTION_NAME)
//       .doc(id);
//   await addressDocReference.delete();
//   return true;
// }

}

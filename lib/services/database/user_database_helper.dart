import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mm_seller_dashboard/models/Address.dart';
import 'package:mm_seller_dashboard/services/authentication_service/authentication_service.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "sellers";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";

  static const String PHONE_KEY = 'phone';
  static const String EMAIL_KEY = 'email';
  static const String NAME_KEY = 'name';
  static const String DP_KEY = "display_picture";

  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewUser(
      String uid, String email, String phone, String name) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set(
        {DP_KEY: null, PHONE_KEY: phone, EMAIL_KEY: email, NAME_KEY: name});
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthenticationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);

    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<List<String>> get addressesList async {
    String uid = AuthenticationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final addresses = List<String>();
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });

    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    String uid = AuthenticationService().currentUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id)
        .get();
    final address = Address.fromMap(doc.data(), id: doc.id);
    return address;
  }

  Future<bool> addAddressForCurrentUser(Address address) async {
    String uid = AuthenticationService().currentUser.uid;
    final addressesCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(String id) async {
    String uid = AuthenticationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(Address address) async {
    String uid = AuthenticationService().currentUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<String> getCurrentUserPhoneNumber() async {
    String uid = AuthenticationService().currentUser.uid;
    final doc =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    final phone = doc.data()['phone'];

    return phone;
  }

  Future<String> getCurrentUserEmail() async {
    String email = AuthenticationService().currentUser.email;
    if (email == null) {
      String uid = AuthenticationService().currentUser.uid;
      final doc =
          await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
      final mail = doc.data()['email'];
      return mail;
    }

    return email;
  }

  Future<String> getCurrentUserName() async {
    String uid = AuthenticationService().currentUser.uid;
    final doc =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    final name = doc.data()['name'];
    return name;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthenticationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthenticationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthenticationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthenticationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthenticationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> getDisplayPictureForCurrentUser() async {
    String uid = AuthenticationService().currentUser.uid;
    final userDocSnapshot =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[DP_KEY];
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthenticationService().currentUser.uid;
    final userDocSnapshot =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[DP_KEY];
  }
}

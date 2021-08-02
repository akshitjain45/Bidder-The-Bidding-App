import 'package:firebase_auth/firebase_auth.dart';
import 'package:bidding_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDBServices {
  final usersRef = FirebaseFirestore.instance.collection('users');

  Future<AppUser?> getData(String id) async {
    DocumentSnapshot snapshot = await usersRef.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return AppUser.fromDocument(snapshot);
  }

  Stream<AppUser?> streamData(String? uid) => uid == null
      ? Stream.empty()
      : usersRef.doc(uid).snapshots().map((snapshot) {
          if (!snapshot.exists) {
            return null;
          }
          return AppUser.fromDocument(snapshot);
        });

  Future<void> createUserData(User user,
      {Map<String, dynamic>? overides}) async {
    Map<String, dynamic> userData = {};
    userData["gender"] = "";
    userData['id'] = user.uid;
    userData['photoUrl'] =
        "https://avatars.dicebear.com/api/jdenticon/${user.uid}.svg";
    userData['email'] = user.email;
    userData['displayName'] = user.displayName ?? "";
    userData['profileCreatedTime'] = DateTime.now();
    userData['phoneNo'] = user.phoneNumber;
    userData['address'] = null;
    if (overides != null) {
      overides.forEach((key, value) {
        userData[key] = value;
      });
    }
    return usersRef.doc(user.uid).set(userData, SetOptions(merge: true));
  }

  Future<void> updateData(String uid,
      {required Map<String, dynamic> data}) async {
    await usersRef.doc(uid).update(data);
  }

  Future<String?> getNotificationToken(String uid) async {
    return usersRef
        .doc(uid)
        .get()
        .then<String>((value) => value.data()!['notificationToken'].toString());
  }

  Future<void> updateNotificationToken(
      String uid, String notificationToken) async {
    await usersRef.doc(uid).update({'notificationToken': notificationToken});
  }

  Future<void> removeNotificationToken(String uid) async {
    await usersRef.doc(uid).update({'notificationToken': FieldValue.delete()});
  }

  // List<InAppNotification> fetchInAppNotifs() {
  //   // SPUtils.getInAppNotifs();
  // }
}

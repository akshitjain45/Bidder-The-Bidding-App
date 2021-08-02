import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? id;
  final String? displayName;
  final String? photoUrl;
  final DateTime? dob;
  final String? email;
  final String? gender;
  final String? notificationToken;
  final String? phoneNo;
  final String? address;
  final DateTime? profileCreatedTime;
  AppUser({
    this.id,
    this.photoUrl,
    this.email,
    this.displayName,
    this.phoneNo,
    this.gender,
    this.dob,
    this.address,
    this.profileCreatedTime,
    this.notificationToken,
  });
//creates object within the class which uses them
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      id: doc.id,
      email: doc.data()!['email'].toString(),
      photoUrl: doc.data()!['photoUrl'].toString(),
      displayName: doc.data()!['displayName'].toString(),
      phoneNo: doc.data()!['phoneNo'] != null
          ? doc.data()!['phoneNo'].toString()
          : "",
      address: doc.data()!['address'] != null
          ? doc.data()!['address'].toString()
          : "",
      notificationToken: doc.data()!['notificationToken'].toString(),
      gender: doc.data()!['gender'].toString(),
      dob: doc.data()!['dob'] != null
          ? DateTime.parse(
              (doc.data()!['dob'] as Timestamp).toDate().toString())
          : null,
      profileCreatedTime: DateTime.parse(
          (doc.data()!['profileCreatedTime'] as Timestamp).toDate().toString()),
    );
  }
}

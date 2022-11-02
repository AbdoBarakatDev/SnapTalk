import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static bool? isDark;
  static SharedPreferences? shared;

  static Future init() async {
    shared = await SharedPreferences.getInstance();
  }

  static Future putBoolean({required String key, required bool value}) async {
    return await shared?.setBool(key, value);
  }

  static getBoolean({required String key}) {
    return shared?.getBool(key);
  }

  static Future putData(
      {@required String? key, @required dynamic value}) async {
    if (value is bool) return await shared?.setBool(key!, value);
    if (value is String) return await shared?.setString(key!, value);
    if (value is double) return await shared?.setDouble(key!, value);
    if (value is int) return await shared?.setInt(key!, value);
  }

  // static saveUser(User user) async {
  //   FirebaseFirestore _db = FirebaseFirestore.instance;
  //   Map<String, dynamic> userData = {
  //     "name": user.displayName,
  //     "email": user.email,
  //     "uId":user.uid,
  //     "phone":"",
  //   };
  //   try {
  //     final userRef = _db.collection("users").doc(user.uid);
  //     if ((await userRef.get()).exists) {
  //       await userRef.update({});
  //     } else {
  //       await _db
  //           .collection("users")
  //           .doc(user.uid)
  //           .set(userData, SetOptions(merge: true));
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  static dynamic getData({@required String? key}) {
    return shared?.get(key!);
  }

  static Future<bool?> clearData({@required String? key}) async {
    return await shared?.remove(key!);
  }
}

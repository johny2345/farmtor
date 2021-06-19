import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmtor/widgets/widgetProperty.dart';

class ApiProvider {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Null> signOut() async {
    debugPrint('--------USER SIGNED OUT--------');
    await auth.signOut();
  }

  Future<dynamic> adminGetAppointments() async {
    return await Firestore.instance
        .collection('users')
        .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
        .collection('schedules')
        .snapshots();
  }

  Future<bool> addAppointment(
      area, details, fullName, date, time, phoneNum, userId, isAdmin) async {
    bool isApproved = false;
    if (isAdmin == true) {
      isApproved = true;
    }
    DateTime schedule =
        DateTime(date.year, date.month, date.day, time.hour, time.minute, 0);
    print(schedule);
    print('Details: ' + details.toString());
    print('Area: ' + area.toString());
    print('Appointee: ' + fullName.toString());

    try {
      await Firestore.instance
          .collection('users')
          .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
          .collection('schedules')
          .add({
        'area': area,
        'details': details,
        'dateSchedule': schedule,
        'appointee': fullName,
        'isApproved': isApproved,
        'phoneNumber': phoneNum,
        'userId': userId,
        'isAdmin': isAdmin,
      }).then((value) {});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteAppt(documentID) async {
    debugPrint('------TO PRINT ID OF APPOINTMENTid---------');
    print(documentID.toString());
    try {
      await Firestore.instance
          .collection('users')
          .document('g0qNuyJB2tbRsolH1OJB31RBDYj2')
          .collection('schedules')
          .document(documentID)
          .delete()
          .then((value) {
        debugPrint('-----SCHEDULE HAS BEEN DELETED SUCCESSFULLY------');
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future signIn(email, password) async {
    print('sign in: ' + email.toString() + '' + password.toString() + '----');
    FirebaseUser user;
    // var userId;
    // try {
    //   user = (await FirebaseAuth.instance
    //           .signInWithEmailAndPassword(email: email, password: password))
    //       .user;
    //   userId = user.uid;
    //   return userId;
    // } catch (e) {
    //   debugPrint(e.toString());
    //   return false;
    // }
  }
}

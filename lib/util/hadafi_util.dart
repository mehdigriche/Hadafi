import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/model/hadaf.dart';

bool isHadafCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Hadaf> hadafs) {
  Map<DateTime, int> dataset = {};

  for (var hadaf in hadafs) {
    for (var date in hadaf.completedDays) {
      // normalize date to avoid time mismatch
      final normalizeDate = DateTime(date.year, date.month, date.day);

      // if the date already exist in dataset
      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        // else initialize it with a count of 1
        dataset[normalizeDate] = 1;
      }
    }
  }
  return dataset;
}

// verify full name
bool isFullNameVerified(String fullname) {
  final RegExp nameRegExp = RegExp('(^[A-Za-z]{3,16})');
  return nameRegExp.hasMatch(fullname);
}

// fetch user details
Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
    User? currentUser) async {
  return await FirebaseFirestore.instance
      .collection("Users")
      .doc(currentUser!.email)
      .get();
}

// get user fullname
Future<String> displayUserName(User? currentUser) async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await getUserDetails(currentUser);
    if (snapshot.exists) {
      var data = snapshot.data();
      debugPrint(data.toString());
      if (data != null && data.containsKey('fullname')) {
        return data['fullname'];
      }
    }
  }
  // Return google username
  return currentUser!.displayName.toString();
}

// get user birthday
Future<String> displayBirthDay(User? currentUser) async {
  if (currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await getUserDetails(currentUser);
    if (snapshot.exists) {
      var data = snapshot.data();
      debugPrint(data.toString());
      if (data != null && data.containsKey('birthday')) {
        return data['birthday'];
      }
    }
  }
  return 'User not found';
}

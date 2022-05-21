import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_financial_management/app/utils/constances.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;

class BudgetRepository {
  Future<Map<String, dynamic>> getMonthlyBudget(DateTime month) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<Map<String, dynamic>> res = await Dio().get(
          '$IPAddressTan/api/budget',
          options: Options(headers: {'AuthToken': token}),
          queryParameters: {'timestamp': month.toString()});
      Map<String, dynamic>? result = res.data;
      return result!;
    } catch (error) {
      throw error;
    }
  }
}

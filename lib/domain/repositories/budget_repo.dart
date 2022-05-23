import 'dart:async';
import 'dart:convert';

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

  Future<Map<String, dynamic>> getBudgetDetail(DateTime timestamp) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<Map<String, dynamic>> res = await Dio().get(
          '$IPAddressTan/api/budget/detail',
          options: Options(headers: {'AuthToken': token}),
          queryParameters: {'timestamp': timestamp.toString()});
      Map<String, dynamic>? result = res.data;
      return result!;
    } catch (error) {
      throw error;
    }
  }

  Future<String> createCategoryBudget(
      {required DateTime timestamp,
      required String category_id,
      required num amount}) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<String> res = await Dio().post(
          '$IPAddressTan/api/budget/category',
          options: Options(headers: {'AuthToken': token}),
          data: jsonEncode({
            "month": timestamp.toString(),
            "category_id": category_id,
            "amount": amount
          }));
      String? result = res.data;
      return result!;
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> createTotalBudget(
      {required DateTime timestamp, required num amount}) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<Map<String, dynamic>> res = await Dio().post(
          '$IPAddressTan/api/budget',
          options: Options(headers: {'AuthToken': token}),
          data: jsonEncode({"month": timestamp.toString(), "amount": amount}));
      Map<String, dynamic>? result = res.data;
      return result!;
    } catch (error) {
      throw error;
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_financial_management/app/utils/constances.dart';
import 'package:personal_financial_management/domain/models/category.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;

class CategoryRepository {
  // type: 'output' or 'input'
  Future<List<String>> getCategories(String type) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<List<String>> res = await Dio().get('$IPAddress/api/category',
          options: Options(headers: {'AuthToken': token}),
          queryParameters: {'is_output': type});
      List<String>? result = res.data;
      return result!;
    } catch (error) {
      throw error;
    }
  }

  Future<Category> createCategory(String name, bool isOutput) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<Map<String, dynamic>> res = await Dio().post(
          '$IPAddress/api/category',
          options: Options(headers: {'AuthToken': token}),
          data: jsonEncode({"name": name, "is_output": isOutput}));
      Map<String, dynamic>? result = res.data;
      return Category.fromJson(result!);
    } catch (error) {
      throw error;
    }
  }
}

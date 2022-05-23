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
      Response<List>? res = await Dio().get(
        '$IPAddressTan/api/category',
        options: Options(headers: {'AuthToken': token}),
        queryParameters: {'is_output': type},
      );

      List<String>? result = res.data!.map((e) => e as String).toList();

      print(result);
      return result;
    } catch (error) {
      throw error;
    }
  }

  Future<Category> createCategory(
      {required String name, required bool isOutput}) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<Map<String, dynamic>> res = await Dio().post(
          '$IPAddressTan/api/category',
          options: Options(headers: {'AuthToken': token}),
          data: jsonEncode({"name": name, "is_output": isOutput}));
      Map<String, dynamic>? result = res.data;
      print(result);
      return Category.fromJson(result!);
    } catch (error) {
      throw error;
    }
  }
}

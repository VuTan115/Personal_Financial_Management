import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_financial_management/app/utils/constances.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;

class TransactionRepository {
  Future<List<t.Transaction>> getTransactions(
      DateTime qTimestamp, TransactionFilter filter) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<List> res = await Dio().get('$IPAddressTan/api/transaction',
          options: Options(headers: {'AuthToken': token}),
          queryParameters: {
            'timestamp': qTimestamp.toString(),
            'filter': filter.toString()
          });
      List? arr = res.data;
      return arr!.map((element) => t.Transaction.fromJson(element)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<List<t.Transaction>> getWalletTransactions(String wallet_id) async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      Response<List> res = await Dio().get(
          '$IPAddressTan/api/transaction/wallet',
          options: Options(headers: {'AuthToken': token}),
          queryParameters: {'wallet_id': wallet_id});
      List? arr = res.data;
      return arr!.map((element) => t.Transaction.fromJson(element)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<List<t.Transaction>> getAllTransactions() async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Response<List> res = await Dio().get(
      '$IPAddressTan/api/transaction/all',
      options: Options(headers: {'AuthToken': token}),
    );
    List? arr = res.data;
    return arr!.map((element) => t.Transaction.fromJson(element)).toList();
  }

  Future<t.Transaction> createTransaction(
    num amount,
    bool is_output,
    String category,
    String wallet,
    DateTime created_at,
  ) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var data = {
      "amount": amount,
      "is_output": is_output,
      "category": category,
      "wallet": wallet,
      "created_at": created_at.toString(),
    };
    Response<Map<String, dynamic>> res = await Dio().post(
        '$IPAddressTan/api/transaction',
        options: Options(headers: {'AuthToken': token}),
        data: jsonEncode(data));
    Map<String, dynamic>? json = res.data;

    return t.Transaction.fromJson(json!);
  }
}

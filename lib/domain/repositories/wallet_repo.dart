import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_financial_management/app/utils/constances.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;
import 'package:personal_financial_management/domain/models/wallet.dart';

class WalletRepository {
  Future<Map<String, dynamic>> getAllWallets() async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Response<List> res = await Dio().get(
      '$IPAddressTan/api/wallet',
      options: Options(headers: {'AuthToken': token}),
    );
    List? arr = res.data;
    Map<String, dynamic> result = {
      "bank": [],
      "credit": [],
      "e_wallet": [],
      "stock": [],
      "cash": [],
    };
    arr!.forEach((element) {
      result[element["type"]].add(new Wallet.fromJson(element));
    });
    return result;
  }

  Future<Wallet> createWallet(
    num amount,
    String name,
    String type,
    String description,
  ) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var data = {
      "amount": amount,
      "name": name,
      "type": type,
      "description": description
    };
    Response<Map<String, dynamic>> res = await Dio().post(
        '$IPAddressTan/api/wallet',
        options: Options(headers: {'AuthToken': token}),
        data: jsonEncode(data));
    Map<String, dynamic>? json = res.data;

    return Wallet.fromJson(json!);
  }
}

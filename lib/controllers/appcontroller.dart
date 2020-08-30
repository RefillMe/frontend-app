import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';

import '../classes/login.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final box = GetStorage();

  static Map<String, String> _api = {
    'login': 'http://192.168.0.118:8080/api/auth/signin',
  };

  bool isLoading = false;

  String _furnitureId = "";

  @override
  void onInit() {
    super.onInit();
  }

  /* Login service */
  Future<bool> login(String username, String password) async {
    print('$username and $password');

    try {
      var response = await http.post(
        _api['login'],
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': '$username',
          'password': '$password',
        }),
      );

      //Decoding and saving data to storage maybe
      Map userMap = jsonDecode(response.body);
      Login test = Login.fromJson(userMap);

      print(test.accessToken);

      if (response.statusCode == 200) {
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      print("***** Invalid account ${_api['login']} $username $password $e");
      isLoading = false;
      update();
      return false;
    }
  }

  String getString(String key, String defaultValue) {
    box.writeIfNull(key, defaultValue);
    return box.read(key);
  }

  String getLoginUsername() {
    box.writeIfNull('username', '');
    return box.read('username');
  }

  String getLoginPassword() {
    box.writeIfNull('password', '');
    return box.read('password');
  }

  void setCredential(email, password) async {
    print("Set Credential $email");
    box.write('username', email);
    box.write('password', password);
  }

    void setFilter(String furnitureId) {
    _furnitureId = furnitureId;
    update();
  }

  String getFilter() {
    return _furnitureId;
  }

}
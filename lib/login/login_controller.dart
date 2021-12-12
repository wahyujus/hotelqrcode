import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelapp/root.dart';

class LoginController extends GetxController {
  var box = GetStorage();
  var username = TextEditingController();
  var password = TextEditingController();

  List<dynamic> initLogin = [];

  String keyAccounts = 'accounts';
  String keyMyAccount = 'my-account';
  String keyAuth = 'auth';

  static LoginController find = Get.find();

  List<dynamic> get accountsDB => box.read(keyAccounts) ?? initLogin;
  Map<String, dynamic> get myAccount => box.read(keyMyAccount);
  bool get isLogged => box.read(keyAuth) ?? false;

  @override
  void onInit() {
    // resetApp();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> createAccount() async {
    EasyLoading.show();
    Map<String, dynamic> newAccount = {
      'username': username.text,
      'password': password.text,
    };

    username.clear();
    password.clear();

    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();

    if (newAccount['username'].toString().isEmpty) {
      EasyLoading.showInfo('id cannot be empty');
      return;
    }

    if (accountsDB.isEmpty) {
      accountsDB.add(newAccount);
      box.write(keyAccounts, accountsDB);
      update();
    } else {
      var isDuplicated = false;
      for (var account in accountsDB) {
        if (account['username'] == newAccount['username']) {
          isDuplicated = true;
          EasyLoading.showError('duplicate id');
          return;
        }
      }

      if (isDuplicated == false) {
        accountsDB.add(newAccount);
        box.write(keyAccounts, accountsDB);
        EasyLoading.showSuccess('id has been created');
        update();
      }
    }

    update();
  }

  Future<bool> loginAccount() async {
    EasyLoading.show();

    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();

    var isValid = false;
    var tempAccount;

    for (var account in accountsDB) {
      if (account['username'] == username.text &&
          account['password'] == password.text) {
        tempAccount = account;
        isValid = true;
        box.write(keyAuth, true);
        box.write(keyMyAccount, tempAccount);
        return isValid;
      }
    }

    box.write(keyAuth, false);
    isValid = false;
    return isValid;
  }

  Future loginAuth() async {
    var valid = await loginAccount();

    if (valid) {
      username.clear();
      password.clear();
      Get.offAll(() => Root());
      alertSuccess(title: 'login sukses', subtitle: '${myAccount['username']}');
    } else {
      alertFail(title: 'login gagal', subtitle: 'user not found');
    }
  }

  void alertFail({required String title, required String subtitle}) {
    Get.snackbar(
      title,
      subtitle,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void alertSuccess({required String title, required String subtitle}) {
    Get.snackbar(
      title,
      subtitle,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }

  void authCreate() {
    username.clear();
    password.clear();
    Get.dialog(
      AlertDialog(
        title: Text('Buat Akun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 35,
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 35,
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('cancel')),
          ElevatedButton(
              onPressed: () async {
                await createAccount();
                Get.back();
              },
              child: Text('daftar')),
        ],
      ),
    );
  }

  void logout() {
    box.remove(keyAuth);
    update();
  }

  void deleteAccount(int index) {
    var temp = accountsDB;
    temp.removeAt(index);
    box.write(keyAccounts, temp);
    update();
  }

  void resetApp() {
    box.remove(keyAccounts);
    box.remove(keyMyAccount);
    box.remove(keyAuth);
    update();
  }
}

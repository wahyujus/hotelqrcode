import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/home/home.dart';
import 'package:hotelapp/login/login.dart';

import 'login/login_controller.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return controller.isLogged == false ? Login() : Home();
      },
    );
  }
}

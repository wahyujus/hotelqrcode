import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/resource.dart';

import 'login_controller.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
              body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: buildContent(controller),
              )
            ],
          )),
        );
      },
    );
  }

  Padding buildContent(LoginController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.1),
            Image.asset('assets/login_banner.png'),
            const Text(
              'Find your best staycation',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _spaceH,
            const Text(
              'You can easily booking any room for your life in this platform with easy and fast',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: controller.username,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _spaceH,
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: controller.password,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 40,
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Resource.instance.appColor.primaryColor),
                    ),
                    onPressed: () {
                      controller.loginAuth();
                    },
                    child: const Text('Login'))),
            _spaceH,
            SizedBox(
                height: 40,
                width: double.maxFinite,
                child: OutlinedButton(
                    onPressed: () {
                      controller.authCreate();
                    },
                    child: const Text('Daftar'))),
            SizedBox(height: Get.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget get _spaceW => const SizedBox(width: 10);
  Widget get _spaceH => const SizedBox(height: 10);
}

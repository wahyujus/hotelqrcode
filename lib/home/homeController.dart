import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelapp/login/login_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeController extends GetxController {
  LoginController get loginController => LoginController.find;

  final qrKey = GlobalKey(debugLabel: 'QR');
  var barcode = 'Scanning...'.obs;

  var selectedTab = 0;
  var box = GetStorage();
  var keyMyOrder = 'my-order';

  var item = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'order'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'user'),
  ];

  var hotelList = [
    {
      'title': 'Aliston Papilio by Aliston',
      'star': '4.5',
      'img': 'assets/hotels/1.jpg',
      'status': 'unpaid',
      'pin': '1234'
    },
    {
      'title': 'Ascott Waterplace Surabaya',
      'star': '4.4',
      'img': 'assets/hotels/2.jpeg',
      'status': 'unpaid',
      'pin': '1234'
    },
    {
      'title': 'Bumi Surabaya City Resort',
      'star': '4.3',
      'img': 'assets/hotels/3.jpeg',
      'status': 'unpaid',
      'pin': '1234'
    },
    {
      'title': 'Ciputra World Hotel Surabaya',
      'star': '4.2',
      'img': 'assets/hotels/4.jpeg',
      'status': 'unpaid',
      'pin': '1234'
    },
    {
      'title': 'J.W. Marriott Surabaya Hotel',
      'star': '4.1',
      'img': 'assets/hotels/5.jpeg',
      'status': 'unpaid',
      'pin': '1234'
    },
  ];

  String get titleIndex => selectedTab == 0
      ? 'Welcome to Hotel QR Code'
      : selectedTab == 1
          ? 'Current Order'
          : 'User List';

  List<dynamic> get myOrder => box.read(keyMyOrder) ?? [];
  bool isPaid(String status) => status == 'paid'
      ? true
      : isCheck(status)
          ? true
          : false;
  bool isCheck(String status) => status == 'check-in' ? true : false;

  @override
  void onInit() {
    // TODO: implement onInit
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

  void changedTab(int index) {
    selectedTab = index;
    update();
  }

  Future<void> addOrder({required Map<String, dynamic> order}) async {
    EasyLoading.show();
    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();

    var isDuplicated = handleDuplicate(
      order: order,
      storageList: myOrder,
      keyStorage: keyMyOrder,
    );

    if (isDuplicated == true) return;
    Get.back();
    changedTab(1);
  }

  bool handleDuplicate({
    required Map<String, dynamic> order,
    required List<dynamic> storageList,
    required String keyStorage,
  }) {
    if (storageList.isEmpty) {
      storageList.add(order);
      box.write(keyStorage, storageList);
      EasyLoading.showSuccess('order has been created');
      update();
      return false;
    } else {
      var isDuplicated = false;
      for (var item in storageList) {
        if (item['title'] == order['title']) {
          isDuplicated = true;
          EasyLoading.showError('duplicated order');
          return isDuplicated;
        }
      }

      if (isDuplicated == false) {
        storageList.add(order);
        box.write(keyStorage, storageList);
        EasyLoading.showSuccess('order has been created');
        update();
        return isDuplicated;
      } else {
        return isDuplicated;
      }
    }
  }

  void removeOrder(int index) {
    myOrder.removeAt(index);
    box.write(keyMyOrder, myOrder);
    update();
  }

  void popRemoveOrder(String orderTitle) {
    Get.defaultDialog(
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.back();
        removeOrderByName(orderTitle);
        Get.back();
      },
      content: const Text('are you sure want to cancel order?'),
    );
  }

  Future<void> editOrder({
    required String orderTitle,
    bool? isPaid,
    bool? isCheckIn,
  }) async {
    EasyLoading.show();
    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();

    var parentIndex =
        myOrder.indexWhere((element) => element['title'] == orderTitle);

    if (isPaid == true) {
      myOrder[parentIndex]['status'] = 'paid';
      box.write(keyMyOrder, myOrder);
      update();

      loginController.alertSuccess(
          title: 'Pembayaran Berhasil', subtitle: 'Silahkan Check In');
    }

    if (isCheckIn == true) {
      var toggle = isCheck(myOrder[parentIndex]['status']);
      toggle = !toggle;
      if (toggle) {
        myOrder[parentIndex]['status'] = 'check-in';
        box.write(keyMyOrder, myOrder);
        update();
        loginController.alertSuccess(
            title: 'Check-In Berhasil', subtitle: 'Selamat Datang');
      } else {
        myOrder[parentIndex]['status'] = 'check-out';
        box.write(keyMyOrder, myOrder);
        update();
        loginController.alertSuccess(
            title: 'Check-Out Berhasil', subtitle: 'Terima Kasih');
      }
    }
  }

  void removeOrderByName(String orderTitle) {
    var parentIndex =
        myOrder.indexWhere((element) => element['title'] == orderTitle);
    myOrder[parentIndex]['status'] = 'unpaid';
    box.write(keyMyOrder, myOrder);
    update();
    myOrder.removeAt(parentIndex);
    box.write(keyMyOrder, myOrder);
    update();
  }

  void onQRViewCreated({
    required QRViewController controller,
    QRViewController? qrViewController,
    required String? hotelID,
  }) {
    qrViewController = controller;
    update();

    controller.scannedDataStream.listen((event) async {
      print(event.code);
      barcode.value = event.code ?? 'Scanning...';

      if (event.code == hotelID) {
        controller.stopCamera();
        toggleCheckIn(code: event.code!);
      } else {
        controller.stopCamera();
        EasyLoading.show();
        await Future.delayed(Duration(seconds: 1));
        EasyLoading.showToast('order id not match');
        Get.back();
      }

      update();
    });
  }

  Future<void> toggleCheckIn({required String code}) async {
    EasyLoading.show();
    await Future.delayed(Duration(seconds: 1));
    EasyLoading.showInfo(code);
    editOrder(orderTitle: code, isCheckIn: true);
    Get.back();
  }
}

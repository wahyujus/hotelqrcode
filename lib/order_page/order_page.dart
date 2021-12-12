import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/detail_order/detail_order.dart';
import 'package:hotelapp/home/homeController.dart';
import 'package:line_icons/line_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return controller.myOrder.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    LineIcons.github,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text('Order Masih kosong'),
                ],
              ))
            : ListView.builder(
                itemCount: controller.myOrder.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Get.to(() =>
                                DetailOrder(hotel: controller.myOrder[index]));
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                Image.asset(controller.myOrder[index]['img'])
                                    .image,
                          ),
                          title: Text(controller.myOrder[index]['title']),
                          subtitle: Text(
                            ' ${controller.myOrder[index]['status']} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                background: Paint()..color = Colors.red),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Pin Room QR Code',
                                  content: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: QrImage(
                                        data: controller.myOrder[index]
                                            ['title'],
                                        size: 200,
                                      )),
                                );
                              },
                              icon: Icon(LineIcons.qrcode)),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/home/homeController.dart';
import 'package:hotelapp/resource.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({Key? key, required this.hotel}) : super(key: key);

  final Map<String, dynamic> hotel;

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  QRViewController? qrViewController;

  @override
  void dispose() {
    // TODO: implement dispose
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await qrViewController!.pauseCamera();
    } else {
      qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dummy = [
      {
        'title': 'Date',
        'subtitle':
            '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}',
      },
      {
        'title': 'Guess',
        'subtitle': '2 Adults',
      },
      {
        'title': 'Sleeps',
        'subtitle': '1 Full Bed',
      },
    ];
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Stays'),
            actions: [
              IconButton(
                  onPressed: () {
                    controller.popRemoveOrder(widget.hotel['title']);
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
          body: buildContent(dummy, controller, widget.hotel),
          bottomSheet: controller.isPaid(widget.hotel['status'])
              ? SizedBox.shrink()
              : Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price :'),
                              Text('Rp 299.999',
                                  style: Resource.instance.appText.h1),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () {
                                controller.editOrder(
                                    orderTitle: widget.hotel['title'],
                                    isPaid: true);
                                Get.back();
                              },
                              child: Text(
                                'Pay',
                                style: Resource.instance.appText.h1,
                              )),
                        ))
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Padding buildContent(
      List<Map<String, dynamic>> dummy, HomeController controller, hotel) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.asset(
                        widget.hotel['img'],
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.hotel['title']}',
                        style: Resource.instance.appText.h1,
                      ),
                      Text(
                        ' ${widget.hotel['status']} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            background: Paint()..color = Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ExpansionTile(
                initiallyExpanded: !controller.isPaid(widget.hotel['status']),
                title: const Text('Details'),
                children: List.generate(
                    dummy.length,
                    (index) => ListTile(
                          title: Text(dummy[index]['title']!),
                          subtitle: Text(dummy[index]['subtitle']!),
                        )),
              ),
            ),
            controller.isPaid(widget.hotel['status'])
                ? ExpansionTile(
                    initiallyExpanded:
                        controller.isPaid(widget.hotel['status']),
                    title: const Text('SCAN QR CODE'),
                    children: [
                        ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(LineIcons.qrcode),
                          ),
                          title: Text(hotel['status'] == 'paid'
                              ? 'check-in'
                              : hotel['status'] == 'check-in'
                                  ? 'check-out'
                                  : hotel['status']),
                          onTap: () => showBarModalBottomSheet(
                            expand: true,
                            context: Get.context!,
                            builder: (context) => Material(
                              child: CupertinoPageScaffold(
                                  navigationBar: CupertinoNavigationBar(
                                      leading: Container(),
                                      middle: Text('Scan QR')),
                                  child: Container(
                                    height: Get.height,
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        QRView(
                                          key: controller.qrKey,
                                          onQRViewCreated: (main) {
                                            controller.onQRViewCreated(
                                                hotelID: hotel['title'],
                                                controller: main,
                                                qrViewController:
                                                    qrViewController);
                                          },
                                          overlay: QrScannerOverlayShape(
                                              borderLength: 20,
                                              borderWidth: 10,
                                              cutOutSize: Get.width * 0.8),
                                        ),
                                        Positioned.fill(
                                            bottom: 30,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.white,
                                                  ),
                                                  child: Obx(() => Text(
                                                      controller
                                                          .barcode.value))),
                                            ))
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ])
                : buildPaymentMethod(),
          ],
        ),
      ),
    );
  }

  Column buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Payment Method',
            style: Resource.instance.appText.h1,
          ),
        ),
        Card(
          color: Resource.instance.appColor.primaryColor,
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  LineIcons.visaCreditCard,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Card',
                      style: Resource.instance.appText.body
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'MasterCard - 2789',
                      style: Resource.instance.appText.body.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

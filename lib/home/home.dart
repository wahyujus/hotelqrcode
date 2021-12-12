import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/discovery/discovery_page.dart';
import 'package:hotelapp/order_page/order_page.dart';
import 'package:line_icons/line_icons.dart';

import '../resource.dart';
import 'homeController.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.titleIndex),
          ),
          body: IndexedStack(
            index: controller.selectedTab,
            children: [
              DiscoveryPage(),
              OrderPage(),
              user(controller),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedTab,
            items: controller.item,
            onTap: controller.changedTab,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: controller.selectedTab != 2
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.changedTab(0);
                        controller.loginController.logout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 10),
                          Text(
                            'KELUAR',
                            style: Resource.instance.appText.h1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  CustomScrollView user(HomeController controller) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: buildListUser(controller),
        )
      ],
    );
  }

  ListView buildListUser(HomeController controller) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.loginController.accountsDB.length,
      itemBuilder: (BuildContext context, int index) {
        var listItem = controller.loginController.accountsDB[index];
        return ListTile(
          leading: Icon(
            LineIcons.userCircleAlt,
            size: 50,
          ),
          title: Text(listItem['username']),
          subtitle: Text(listItem['password']
              .toString()
              .replaceRange(1, listItem['password'].toString().length, '@')),
          trailing: IconButton(
              onPressed: () {
                controller.loginController.deleteAccount(index);
              },
              icon: Icon(Icons.delete)),
        );
      },
    );
  }
}

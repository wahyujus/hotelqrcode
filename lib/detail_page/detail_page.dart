import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/home/homeController.dart';
import 'package:hotelapp/resource.dart';
import 'package:line_icons/line_icons.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final Map<String, dynamic> hotel;

  @override
  Widget build(BuildContext context) {
    var faci = ['Center', 'Good Deals', 'Cozy'];
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(hotel['title']),
          ),
          body: buildContents(faci),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () => controller.addOrder(order: hotel),
                child: Text(
                  'Reserve',
                  style: Resource.instance.appText.h1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SingleChildScrollView buildContents(List<String> faci) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Image.asset(
                  hotel['img'],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                top: 20,
                right: 20,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Resource.instance.appColor.primaryColor
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        'Premium',
                        style: Resource.instance.appText.body2,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star),
                    Text(hotel['star']),
                    SizedBox(width: 5),
                    Text('(200 Reviews)'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    buildIconText(icon: LineIcons.bed, title: '1'),
                    SizedBox(width: 10),
                    buildIconText(icon: LineIcons.userFriends, title: '2'),
                    Spacer(),
                    Text(
                      'Rp. 299.999',
                      style: Resource.instance.appText.h1,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Facilites',
                    style: Resource.instance.appText.h1,
                  ),
                ),
                Row(
                  children: List.generate(
                    faci.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: Text(
                            faci[index],
                            style: Resource.instance.appText.body,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                      'Lorem deserunt quis laboris ex pariatur excepteur culpa consequat. Consectetur ea dolore dolore eiusmod deserunt Lorem dolore incididunt ea officia proident deserunt aliqua. Elit reprehenderit ullamco officia nostrud officia.'),
                )
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.1),
        ],
      ),
    );
  }

  Row buildIconText({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: 5,
        ),
        Text(title),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelapp/detail_page/detail_page.dart';
import 'package:hotelapp/home/homeController.dart';
import 'package:hotelapp/resource.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomScrollView(
            slivers: [
              buildHeader(),
              buildRecom(controller.hotelList),
              buildHotels(controller.hotelList),
            ],
          ),
        );
      },
    );
  }

  SliverList buildHotels(List<dynamic> hotels) {
    return SliverList(
        delegate: SliverChildListDelegate([
      buildHeaderList(title: 'Popular Hotels'),
      GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: hotels.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Get.to(() => DetailPage(
                  hotel: hotels[index],
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          hotels[index]['img'],
                          fit: BoxFit.cover,
                          width: 200,
                        ),
                        Positioned.fill(
                          bottom: 15,
                          left: 0,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 55,
                              decoration: BoxDecoration(
                                  color:
                                      Resource.instance.appColor.primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    hotels[index]['star'],
                                    style: Resource.instance.appText.body2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        hotels[index]['title'],
                        maxLines: 1,
                        style: Resource.instance.appText.body,
                      ),
                      Text(
                        'Elit tempor qui elit ea excepteur minim cillum in elit. Esse aliqua qui ullamco exercitation consequat ex do reprehenderit cillum. Qui deserunt ullamco ad anim magna aute cillum elit consequat irure nostrud. Mollit qui do laborum dolore ea culpa pariatur occaecat nisi Lorem aliqua excepteur. Consequat et esse ad dolor.',
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      )
    ]));
  }

  SliverList buildRecom(List<dynamic> hotels) {
    return SliverList(
        delegate: SliverChildListDelegate([
      buildHeaderList(title: 'Recommendation'),
      SizedBox(
        height: 120,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: hotels.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => Get.to(
                () => DetailPage(
                  hotel: hotels[index],
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          hotels[index]['img'],
                          fit: BoxFit.fitHeight,
                          width: 100,
                          height: double.maxFinite,
                        ),
                      ),
                      Positioned.fill(
                        bottom: 0,
                        left: 0,
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 45,
                              color: Colors.black38,
                            )),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        left: 10,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            hotels[index]['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    ]));
  }

  Padding buildHeaderList({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Resource.instance.appText.h1,
          ),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  SliverToBoxAdapter buildHeader() {
    return SliverToBoxAdapter(
      child: CupertinoSearchTextField(
        placeholder: 'Where are you going?',
      ),
    );
  }
}

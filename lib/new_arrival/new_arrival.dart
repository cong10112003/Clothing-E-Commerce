import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/common_widget/top_foodies_user_row.dart';

class TopFoodie extends StatefulWidget {
  const TopFoodie({super.key});

  @override
  State<TopFoodie> createState() => _TopFoodieState();
}

class _TopFoodieState extends State<TopFoodie> {
  var selectTab = 0;
  List reviewsArr = [
    {
      "name": "Jaysen Terrell",
      "images": "assets/img/u1.png",
      "reviews": "385",
      "photos": "145",
      "type": "Diamond Foodie",
      "is_follow": "1",
      "rank": "1",
    },
    {
      "name": "Hibe Neted",
      "images": "assets/img/u2.png",
      "reviews": "89",
      "photos": "75",
      "type": "Gold Foodie",
      "is_follow": "0",
      "rank": "2",
    },
    {
      "name": "Lilja Peltola",
      "images": "assets/img/u1.png",
      "reviews": "120",
      "photos": "456",
      "type": "Gold Foodie",
      "is_follow": "1",
      "rank": "2",
    },
    {
      "name": "Natalia Sanz",
      "images": "assets/img/u2.png",
      "reviews": "452",
      "photos": "23",
      "type": "Silver Foodie",
      "is_follow": "1",
      "rank": "3",
    },
    {
      "name": "Emeline Duarte",
      "images": "assets/img/u1.png",
      "reviews": "156",
      "photos": "47",
      "type": "Silver Foodie",
      "is_follow": "0",
      "rank": "3",
    },
    {
      "name": "Mylan Pierre",
      "images": "assets/img/u1.png",
      "reviews": "156",
      "photos": "47",
      "type": "Silver Foodie",
      "is_follow": "0",
      "rank": "3",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              floating: false,
              centerTitle: false,
              leadingWidth: 0,
              title: Row(
                children: [
                  Image.asset(
                    "assets/img/top_foodies.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "New Arrival",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: TColor.text,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ];
        },
        body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: reviewsArr.length,
            itemBuilder: (context, index) {
              var uObj = reviewsArr[index] as Map? ?? {};
            }),
      ),
    );
  }
}
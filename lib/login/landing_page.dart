import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:food_app/login/check_status_account.dart';
import 'package:food_app/login/login_page.dart';
import 'package:food_app/navigation_controller/admin_bottom-navigation.dart';
import 'package:food_app/navigation_controller/bottom_navigation.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectPage = 0;

  PageController? controller = PageController();

  List infoArr = [
    {
      "title": "All way adapt and evolve",
      "sub_title":
          "",
      "icon": "assets/img/1.png"
    },
    {
      "title": "Keep in my my trending fashion",
      "sub_title":
          "",
      "icon": "assets/img/2.png"
    },
    {
      "title": "Various clothing",
      "sub_title":
          "",
      "icon": "assets/img/3.png"
    },
    {
      "title": "Fast shipping",
      "sub_title":
          "",
      "icon": "assets/img/4.png"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    controller?.addListener(() {
      selectPage = controller?.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.primary,
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
              controller: controller,
              itemCount: infoArr.length,
              itemBuilder: (context, index) {
                var iObj = infoArr[index] as Map? ?? {};

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      iObj["icon"].toString(),
                      width: media.width * 0.5,
                      height: media.width * 0.5,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                    Text(
                      iObj["title"].toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: media.width * 0.03,
                    ),
                    Text(
                      iObj["sub_title"].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                );
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14, 150, 14, 0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Login',style: TextStyle(color: Colors.black),),
                    onPressed: () {
                  
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckStatusAccount() ) );
                  
                    },
                  ),
                ),
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: infoArr.map((iObj) {
                  var index = infoArr.indexOf(iObj);

                  return Container(
                      margin: const EdgeInsets.all(8),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: selectPage == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(7.5)));
                }).toList(),
              )
            ],
          )
        ]),
      ),
    );
  }
}
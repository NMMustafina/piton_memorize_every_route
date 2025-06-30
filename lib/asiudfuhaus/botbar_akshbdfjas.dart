import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piton_memorize_every_route_311_a/asdfhasjd/aksdkjf.dart';
import 'package:piton_memorize_every_route_311_a/asdfhasjd/jsndfk.dart';
import 'package:piton_memorize_every_route_311_a/asdfhasjd/njsdnjfjn.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/color_asdasjndfj.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/moti_asfgsakdf.dart';

import '../screens/home_screen.dart';

class BotomBarasjdjfn extends StatefulWidget {
  const BotomBarasjdjfn({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<BotomBarasjdjfn> createState() => BotomBarasjdjfnState();
}

class BotomBarasjdjfnState extends State<BotomBarasjdjfn> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 115.h,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 20, top: 0, right: 10, left: 10),
        decoration: const BoxDecoration(
          color: Colorajsnjf.background,
          // border: Border(
          //   top: BorderSide(
          //     color: Color(0xFF596279),
          //   ),
          // ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: buildNavItem(
              0,
              'assets/icons/1.png',
              'assets/icons/11.png',
            )),
            Expanded(
                child: buildNavItem(
              1,
              'assets/icons/2.png',
              'assets/icons/22.png',
            )),
            Expanded(
                child: buildNavItem(
              2,
              'assets/icons/3.png',
              'assets/icons/33.png',
            )),
            Expanded(
                child: buildNavItem(
              3,
              'assets/icons/4.png',
              'assets/icons/44.png',
            )),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath, String iconPath2) {
    bool isActive = _currentIndex == index;

    return MotiButsjdnfj(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Center(
          child: Image.asset(
            // isActive ? iconPath : iconPath2,
            iconPath,
            width: 30.w,
            height: 30.h,
            color: isActive ? null : const Color.fromARGB(91, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  final _pages = <Widget>[
    const HomeScreen(),
    const Njsdnjfjn(),
    const Aksdkjf(),
    const Jsndfk(),
  ];
}

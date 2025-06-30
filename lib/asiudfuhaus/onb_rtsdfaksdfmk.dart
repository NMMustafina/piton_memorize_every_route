import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/botbar_akshbdfjas.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/color_asdasjndfj.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/moti_asfgsakdf.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoDiasdbvhjdjhasjbdjfh extends StatefulWidget {
  const OnBoDiasdbvhjdjhasjbdjfh({super.key});

  @override
  State<OnBoDiasdbvhjdjhasjbdjfh> createState() =>
      _OnBoDiasdbvhjdjhasjbdjfhState();
}

class _OnBoDiasdbvhjdjhasjbdjfhState extends State<OnBoDiasdbvhjdjhasjbdjfh> {
  final PageController _controller = PageController();
  int introIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorajsnjf.background,
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                introIndex = index;
              });
            },
            children: const [
              OnWid(
                image: '1',
              ),
              OnWid(
                image: '2',
              ),
              OnWid(
                image: '3',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 660.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    MotiButsjdnfj(
                      onPressed: () {
                        if (introIndex != 2) {
                          _controller.animateToPage(
                            introIndex + 1,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BotomBarasjdjfn(),
                            ),
                            (protected) => false,
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/images/bn_on.png',
                        width: 120.w,
                        height: 75.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotColor: Color.fromARGB(110, 255, 255, 255),
                        activeDotColor: Color(0xffFFFFFF),
                        dotWidth: 15,
                        dotHeight: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnWid extends StatelessWidget {
  const OnWid({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/on$image.png',
      height: 812.h,
      width: 305.w,
      fit: BoxFit.cover,
      // alignment: Alignment.bottomCenter,
    );
  }
}

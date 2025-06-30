import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/challenge_presets.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/route_provider.dart';
import '../widgets/active_challenge_banner.dart';
import '../widgets/route_card.dart';
import 'add_edit_route_screen.dart';
import 'challenge_roulette_screen.dart';
import 'completed_challenges_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<RouteProvider>().routes.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final challenge = context.watch<ChallengeProvider>().activeChallenge;

    final preset = challengePresets.firstWhereOrNull(
      (p) => challenge?.routeKey == p.id,
    );

    final hasHistory = context.watch<ChallengeProvider>().history.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'My routes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/mountain.svg',
              width: 28.w,
              height: 28.w,
              colorFilter: ColorFilter.mode(
                hasHistory ? const Color(0xFFD90000) : const Color(0xFF470E0E),
                BlendMode.srcIn,
              ),
            ),
            onPressed: hasHistory
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CompletedChallengesScreen(),
                      ),
                    );
                  }
                : null,
          )
        ],
      ),
      body: Column(
        children: [
          if (challenge != null && preset != null)
            ActiveChallengeBanner(
              preset: preset,
              challenge: challenge,
            ),
          if (routes.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "You haven't added any\n routes yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: routes.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (_, index) => RouteCard(route: routes[index]),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            IntrinsicWidth(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ChallengeRouletteScreen(
                      presets: challengePresets,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD90000),
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Spin for Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/spin.svg',
                      width: 20.w,
                      height: 20.w,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddEditRouteScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD90000),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Add route',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

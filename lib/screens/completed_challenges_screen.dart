import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/challenge_presets.dart';
import '../../models/challenge.dart';
import '../../models/challenge_preset.dart';
import '../../providers/challenge_provider.dart';
import '../widgets/pick_challenge_time_dialog.dart';

class CompletedChallengesScreen extends StatelessWidget {
  const CompletedChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ChallengeProvider>().history;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Completed challenges',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: history.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, index) {
          final challenge = history[index];
          final preset = challengePresets.firstWhereOrNull(
            (p) => p.id == challenge.routeKey,
          );

          if (preset == null) return const SizedBox.shrink();

          return _ChallengeHistoryCard(
            preset: preset,
            challenge: challenge,
          );
        },
      ),
    );
  }
}

class _ChallengeHistoryCard extends StatelessWidget {
  final ChallengePreset preset;
  final Challenge challenge;

  const _ChallengeHistoryCard({
    required this.preset,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ChallengeProvider>();
    final completed = challenge.completed == true;
    final date = DateFormat('dd.MM.yyyy, HH:mm').format(challenge.endTime);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border.all(color: const Color(0xFFD90000)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2828),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  completed ? 'assets/icons/up.svg' : 'assets/icons/down.svg',
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  preset.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B2828),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      completed ? 'Challenge completed' : 'Deadline was missed',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _iconBox(
                asset: 'assets/icons/delete.svg',
                bgColor: const Color(0xFF743737),
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text('Delete challenge?'),
                      content: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text("You can't get your progress back"),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            provider.deleteChallenge(challenge.key);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(width: 8.w),
              _iconBox(
                asset: 'assets/icons/refresh.svg',
                bgColor: const Color(0xFF743737),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => PickChallengeTimeDialog(
                      onSave: (start, end) {
                        provider.addChallenge(Challenge(
                          routeKey: preset.id,
                          startTime: start,
                          endTime: end,
                        ));
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox({
    required String asset,
    required VoidCallback onTap,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(8.w),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          asset,
          width: 20.w,
          height: 20.w,
          color: Colors.white,
        ),
      ),
    );
  }
}

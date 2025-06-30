import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/challenge.dart';
import '../../models/challenge_preset.dart';
import '../../providers/challenge_provider.dart';
import 'pick_challenge_time_dialog.dart';

class ActiveChallengeBanner extends StatefulWidget {
  final ChallengePreset preset;
  final Challenge challenge;

  const ActiveChallengeBanner({
    super.key,
    required this.preset,
    required this.challenge,
  });

  @override
  State<ActiveChallengeBanner> createState() => _ActiveChallengeBannerState();
}

class _ActiveChallengeBannerState extends State<ActiveChallengeBanner> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _calculate();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculate());
  }

  void _calculate() {
    final now = DateTime.now();
    final diff = widget.challenge.endTime.difference(now);

    if (diff.isNegative && !_expired) {
      setState(() {
        _expired = true;
        _timer?.cancel();
      });
    } else if (!_expired) {
      setState(() => _remaining = diff);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;

    final parts = <String>[
      if (h > 0) '$h h',
      if (m > 0) '$m min',
      '$s sec',
    ];

    return '${parts.join(', ')} left';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ChallengeProvider>();
    final challengeKey = widget.challenge.key as int;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD90000)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.preset.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          if (_expired) ...[
            SizedBox(height: 4.h),
            Text(
              DateFormat('dd.MM.yyyy, HH:mm').format(widget.challenge.endTime),
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF943737),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Your challenge is over!\nDid you make the deadline?',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.completeChallenge(challengeKey, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD90000),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('In time'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.completeChallenge(challengeKey, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD90000),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('Missed'),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF943737),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _formattedTime,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                _iconBox(
                  asset: 'assets/icons/edit.svg',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => PickChallengeTimeDialog(
                        initialStart: widget.challenge.startTime,
                        initialEnd: widget.challenge.endTime,
                        onSave: (start, end) {
                          widget.challenge.startTime = start;
                          widget.challenge.endTime = end;
                          widget.challenge.save();
                          _calculate();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                _iconBox(
                  asset: 'assets/icons/delete.svg',
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: const Text('Delete the challenge data?'),
                        content: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child:
                              Text('Do you want to delete the challenge data?'),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              provider.deleteChallenge(challengeKey);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBox({required String asset, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF943737),
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

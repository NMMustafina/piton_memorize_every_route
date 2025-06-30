import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../models/challenge.dart';
import '../../models/challenge_preset.dart';
import '../../providers/challenge_provider.dart';
import '../widgets/pick_challenge_time_dialog.dart';

class ChallengeRouletteScreen extends StatefulWidget {
  final List<ChallengePreset> presets;
  const ChallengeRouletteScreen({super.key, required this.presets});

  @override
  State<ChallengeRouletteScreen> createState() =>
      _ChallengeRouletteScreenState();
}

class _ChallengeRouletteScreenState extends State<ChallengeRouletteScreen> {
  final ScrollController _scrollController = ScrollController();
  static const double itemHeight = 165;
  static const double separatorHeight = 12;

  int? _selectedIndex;
  bool _spun = false;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.presets.isNotEmpty) {
        _scrollToIndex(widget.presets.length ~/ 2);
      }
    });
  }

  void _scrollToIndex(int index) {
    final containerHeight = MediaQuery.of(context).size.height * 0.6;
    final double scaledItemHeight = itemHeight.h;
    final double scaledSeparatorHeight = separatorHeight.h;
    final double verticalPadding = (containerHeight - scaledItemHeight) / 2;

    final double offset = verticalPadding +
        index * (scaledItemHeight + scaledSeparatorHeight) -
        (containerHeight / 2 - scaledItemHeight / 2);

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final targetOffset = offset.clamp(0.0, maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
  }

  void _spinRoulette() {
    final random = Random();
    int index;
    do {
      index = random.nextInt(widget.presets.length);
    } while (index == _selectedIndex && widget.presets.length > 1);

    setState(() {
      _selectedIndex = index;
      _isSpinning = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollToIndex(index);
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        _spun = true;
        _isSpinning = false;
      });
    });
  }

  void _respin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _spinRoulette();
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.of(context).size.height * 0.6;
    final double verticalPadding = (containerHeight - itemHeight.h) / 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF480505),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(65.r),
                        right: Radius.circular(65.r),
                      ),
                      border:
                          Border.all(color: const Color(0xFFD90000), width: 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: containerHeight,
                          child: Stack(
                            children: [
                              ListView.separated(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(
                                  vertical: verticalPadding,
                                ),
                                itemCount: widget.presets.length,
                                physics: _isSpinning
                                    ? const NeverScrollableScrollPhysics()
                                    : null,
                                itemBuilder: (context, index) {
                                  final selected = index == _selectedIndex;
                                  final opacity =
                                      !_spun ? 1.0 : (selected ? 1.0 : 0.3);
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: opacity,
                                    child: _buildChallengeCard(
                                        widget.presets[index], selected),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: separatorHeight.h),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: SvgPicture.asset(
                                    'assets/icons/play.svg',
                                    width: 28.sp,
                                    height: 28.sp,
                                  ),
                                ),
                              ),
                              if (_spun)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20.w),
                                    child: GestureDetector(
                                      onTap: _respin,
                                      child: Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD90000),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/refresh.svg',
                                          width: 22.sp,
                                          height: 22.sp,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -18.r,
                    right: -18.r,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: const Color(0xFFD90000), width: 1),
                        ),
                        child: Icon(Icons.close,
                            color: const Color(0xFFD90000), size: 24.sp),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isSpinning) return;
                  if (_spun && _selectedIndex != null) {
                    final preset = widget.presets[_selectedIndex!];
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PickChallengeTimeDialog(
                        onSave: (start, end) {
                          final challenge = Challenge(
                            routeKey: preset.id,
                            startTime: start,
                            endTime: end,
                          );
                          Provider.of<ChallengeProvider>(context, listen: false)
                              .addChallenge(challenge);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  } else {
                    _spinRoulette();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD90000),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
                child: Text(
                  _spun && _selectedIndex != null
                      ? 'Choose'
                      : 'Spin the roulette',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(ChallengePreset preset, bool selected) {
    return Center(
      child: Container(
        height: itemHeight.h,
        width: 135.w,
        decoration: BoxDecoration(
          color: const Color(0xFF743737),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD90000), width: 1),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                preset.imageAsset,
                width: 118.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Center(
                child: Text(
                  preset.title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
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

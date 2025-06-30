import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RoutePhotoBlock extends StatelessWidget {
  final String? imagePath;
  final bool isEdit;
  final VoidCallback onPick;
  final VoidCallback onDelete;

  const RoutePhotoBlock({
    super.key,
    required this.imagePath,
    required this.isEdit,
    required this.onPick,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Route photo ',
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
            children: [
              TextSpan(
                text: '(optional)',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 220.h,
                color: const Color(0xFF743737),
                child: imagePath == null
                    ? Center(
                        child: SvgPicture.asset(
                          'assets/icons/pic.svg',
                          width: 48.sp,
                          height: 48.sp,
                          colorFilter: const ColorFilter.mode(
                              Colors.white54, BlendMode.srcIn),
                        ),
                      )
                    : Image.file(
                        File(imagePath!),
                        width: double.infinity,
                        height: 220.h,
                        fit: BoxFit.cover,
                      ),
              ),
              if (imagePath != null)
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Row(
                    children: [
                      if (!isEdit)
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xFFD90000),
                                width: 0.5,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/trash.svg',
                              width: 20.sp,
                              height: 20.sp,
                            ),
                          ),
                        ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: onPick,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFD90000),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              isEdit
                                  ? SvgPicture.asset(
                                      'assets/icons/reset.svg',
                                      width: 18.sp,
                                      height: 18.sp,
                                      colorFilter: const ColorFilter.mode(
                                          Color(0xFFD90000), BlendMode.srcIn),
                                    )
                                  : const SizedBox.shrink(),
                              isEdit
                                  ? const SizedBox.shrink()
                                  : Text(
                                      'Change',
                                      style: TextStyle(
                                        color: const Color(0xFFD90000),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onPick,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

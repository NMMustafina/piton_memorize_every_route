import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/climbing_route.dart';
import '../screens/add_edit_route_screen.dart';

class RouteCard extends StatelessWidget {
  final ClimbingRoute route;
  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEditRouteScreen(initialData: route),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF743737),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (route.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.file(
                  File(route.imagePath!),
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _iconText('assets/icons/location.svg', route.location),
                  if (route.complexity != null)
                    _iconText('assets/icons/complexity.svg', route.complexity!),
                  if (route.height != null)
                    _iconText('assets/icons/ruler.svg', route.height!),
                  _iconText('assets/icons/rock.svg', route.rockType),
                  if (route.description != null) ...[
                    const Divider(color: Colors.white),
                    SizedBox(height: 8.h),
                    Text(
                      route.description!,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _iconText(String assetPath, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 20.sp,
            height: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

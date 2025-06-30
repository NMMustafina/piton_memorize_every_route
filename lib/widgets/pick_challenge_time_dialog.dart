import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'date_time_picker_dialog.dart';

class PickChallengeTimeDialog extends StatefulWidget {
  final void Function(DateTime start, DateTime end) onSave;
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const PickChallengeTimeDialog({
    super.key,
    required this.onSave,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<PickChallengeTimeDialog> createState() =>
      _PickChallengeTimeDialogState();
}

class _PickChallengeTimeDialogState extends State<PickChallengeTimeDialog> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  Future<void> _pickDateTime(bool isStart) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_start ?? now)
        : (_end ??
            _start?.add(const Duration(hours: 1)) ??
            now.add(const Duration(hours: 1)));
    final minDate = isStart ? now : (_start ?? now);

    showDialog(
      context: context,
      builder: (_) => DateTimePickerDialog(
        initialDateTime: initial,
        minDate: minDate,
        onPicked: (picked) {
          setState(() {
            if (isStart) {
              _start = picked;
              if (_end != null && picked.isAfter(_end!)) _end = null;
            } else {
              _end = picked;
            }
          });
        },
      ),
    );
  }

  String _format(DateTime? dt, String fallback) =>
      dt == null ? fallback : DateFormat('dd.MM.yyyy, hh:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A0000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFFD90000)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.initialStart != null && widget.initialEnd != null
                      ? 'Change time'
                      : 'Pick a time',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(Icons.close,
                        size: 20.sp, color: const Color(0xFFD90000)),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.h),
            _buildField(
              _format(_start, 'Select start date and time'),
              () => _pickDateTime(true),
            ),
            SizedBox(height: 12.h),
            _buildField(
              _format(_end, 'Select end date and time'),
              () => _pickDateTime(false),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: (_start != null &&
                      _end != null &&
                      (_start != widget.initialStart ||
                          _end != widget.initialEnd))
                  ? () {
                      widget.onSave(_start!, _end!);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD90000),
                disabledBackgroundColor: const Color(0xFF470E0E),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF743737),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

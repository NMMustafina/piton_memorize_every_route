import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimePickerDialog extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime minDate;
  final void Function(DateTime) onPicked;

  const DateTimePickerDialog({
    super.key,
    required this.initialDateTime,
    required this.minDate,
    required this.onPicked,
  });

  @override
  State<DateTimePickerDialog> createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
  }

  DateTime get combinedDateTime => DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

  Future<void> _showTimePicker() async {
    TimeOfDay selected = _selectedTime;

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SizedBox(
            height: 300.h,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        0,
                        0,
                        0,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      ),
                      use24hFormat: false,
                      onDateTimeChanged: (DateTime newDateTime) {
                        selected = TimeOfDay(
                          hour: newDateTime.hour,
                          minute: newDateTime.minute,
                        );
                      },
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xFF574D4D),
                  thickness: 0.5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFFD90000)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedTime = selected);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Color(0xFFD90000)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _trySave() async {
    final selected = combinedDateTime;

    if (selected
        .isBefore(widget.minDate.subtract(const Duration(minutes: 1)))) {
      await showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoTheme(
          data: const CupertinoThemeData(brightness: Brightness.dark),
          child: CupertinoAlertDialog(
            title: const Text('Invalid time'),
            content: const Text('Please select a valid time in the future.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      );
      return;
    }

    widget.onPicked(selected);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFFD90000)),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFD90000),
                  onPrimary: Colors.white,
                ),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.white),
                  bodyLarge: TextStyle(color: Colors.white),
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(
                  widget.minDate.year,
                  widget.minDate.month,
                  widget.minDate.day,
                ),
                lastDate: DateTime(2100),
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    'Time',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
                GestureDetector(
                  onTap: _showTimePicker,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221212),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _selectedTime.format(context),
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xFF574D4D),
              thickness: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFD90000)),
                  ),
                ),
                TextButton(
                  onPressed: _trySave,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Color(0xFFD90000)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

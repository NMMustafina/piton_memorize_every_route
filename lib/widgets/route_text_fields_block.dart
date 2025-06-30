import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteTextFieldsBlock extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController rockTypeController;
  final TextEditingController complexityController;
  final TextEditingController heightController;
  final TextEditingController descriptionController;
  final VoidCallback onChanged;
  final bool isEdit;

  const RouteTextFieldsBlock({
    super.key,
    required this.nameController,
    required this.locationController,
    required this.rockTypeController,
    required this.complexityController,
    required this.heightController,
    required this.descriptionController,
    required this.onChanged,
    required this.isEdit,
  });

  Widget _buildField(String label, TextEditingController controller,
      {bool optional = false}) {
    final bool isMultiline = label == 'Description' && isEdit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
            children: optional
                ? [
                    const TextSpan(
                      text: ' (optional)',
                      style: TextStyle(color: Colors.grey),
                    )
                  ]
                : [],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          style: const TextStyle(color: Colors.white),
          minLines: isMultiline ? 3 : 1,
          maxLines: isMultiline ? null : 1,
          keyboardType:
              isMultiline ? TextInputType.multiline : TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF743737),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField('Route name', nameController),
        _buildField('Location', locationController),
        _buildField('Rock type', rockTypeController),
        _buildField('Complexity', complexityController, optional: true),
        _buildField('Height/Length', heightController, optional: true),
        _buildField('Description', descriptionController, optional: true),
      ],
    );
  }
}

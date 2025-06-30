import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/climbing_route.dart';
import '../../providers/route_provider.dart';
import '../../widgets/route_photo_block.dart';
import '../../widgets/route_save_button.dart';
import '../../widgets/route_text_fields_block.dart';

class AddEditRouteScreen extends StatefulWidget {
  final ClimbingRoute? initialData;

  const AddEditRouteScreen({super.key, this.initialData});

  @override
  State<AddEditRouteScreen> createState() => _AddEditRouteScreenState();
}

class _AddEditRouteScreenState extends State<AddEditRouteScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _rockTypeController = TextEditingController();
  final _complexityController = TextEditingController();
  final _heightController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _imagePath;
  bool _hasChanges = false;

  bool get _isEdit => widget.initialData != null;
  bool get _isValid =>
      _nameController.text.isNotEmpty &&
      _locationController.text.isNotEmpty &&
      _rockTypeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      _nameController.text = data.name;
      _locationController.text = data.location;
      _rockTypeController.text = data.rockType;
      _complexityController.text = data.complexity ?? '';
      _heightController.text = data.height ?? '';
      _descriptionController.text = data.description ?? '';
      _imagePath = data.imagePath;
    }
  }

  void _onChanged() => setState(() => _hasChanges = true);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
        _hasChanges = true;
      });
    }
  }

  void _deleteRoute() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Delete a route?'),
            content: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Do you want to delete a route?'),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    final box = Provider.of<RouteProvider>(context, listen: false);
    final key = widget.initialData!.key as int;
    await box.deleteRoute(key);
    Navigator.of(context).pop();
  }

  void _saveRoute() {
    final route = ClimbingRoute(
      name: _nameController.text,
      location: _locationController.text,
      rockType: _rockTypeController.text,
      complexity: _complexityController.text.isEmpty
          ? null
          : _complexityController.text,
      height: _heightController.text.isEmpty ? null : _heightController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      imagePath: _imagePath,
    );

    final box = Provider.of<RouteProvider>(context, listen: false);
    if (_isEdit) {
      final key = widget.initialData!.key as int;
      box.updateRoute(key, route);
    } else {
      box.addRoute(route);
    }
    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() async {
    final isAnyFieldFilled = _nameController.text.isNotEmpty ||
        _locationController.text.isNotEmpty ||
        _rockTypeController.text.isNotEmpty ||
        _complexityController.text.isNotEmpty ||
        _heightController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _imagePath != null;

    final shouldShowAlert = _isEdit ? _hasChanges : isAnyFieldFilled;

    if (!shouldShowAlert) return true;

    return await showDialog<bool>(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Want to get out of creating?'),
            content: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Are you confident in your exit?'),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Stay'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Leave'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? 'Edit route' : 'New route',
            style: const TextStyle(color: Colors.white),
          ),
          leading: const BackButton(color: Colors.white),
          actions: [
            if (_isEdit)
              IconButton(
                onPressed: _deleteRoute,
                icon: SvgPicture.asset(
                  'assets/icons/trash.svg',
                  width: 24.w,
                  height: 24.w,
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              RoutePhotoBlock(
                imagePath: _imagePath,
                isEdit: _isEdit,
                onPick: _pickImage,
                onDelete: () => setState(() => _imagePath = null),
              ),
              SizedBox(height: 24.h),
              RouteTextFieldsBlock(
                nameController: _nameController,
                locationController: _locationController,
                rockTypeController: _rockTypeController,
                complexityController: _complexityController,
                heightController: _heightController,
                descriptionController: _descriptionController,
                onChanged: _onChanged,
                isEdit: _isEdit,
              ),
              SizedBox(height: 24.h),
              RouteSaveButton(
                isEdit: _isEdit,
                isEnabled: _isEdit ? _hasChanges : _isValid,
                onPressed: _saveRoute,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void lauchUrlSJdkas(BuildContext context, String urasdfl) async {
  final Uri asdffss = Uri.parse(urasdfl);
  if (!await launchUrl(asdffss)) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch $asdffss'),
      ),
    );
  }
}

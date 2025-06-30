import 'package:flutter/material.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/color_asdasjndfj.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/dok_asfgsasjdfj.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/moti_asfgsakdf.dart';
import 'package:piton_memorize_every_route_311_a/asiudfuhaus/pro_aasdsfasndfj.dart';

class Jsndfk extends StatelessWidget {
  const Jsndfk({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colorajsnjf.white,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 26),
            MotiButsjdnfj(
              onPressed: () {
                lauchUrlSJdkas(context, Dokjasdjnf.priPoli);
              },
              child: Image.asset(
                'assets/images/1.png',
              ),
            ),
            const SizedBox(height: 16),
            MotiButsjdnfj(
              onPressed: () {
                lauchUrlSJdkas(context, Dokjasdjnf.suprF);
              },
              child: Image.asset(
                'assets/images/2.png',
              ),
            ),
            const SizedBox(height: 16),
            MotiButsjdnfj(
              onPressed: () {
                lauchUrlSJdkas(context, Dokjasdjnf.terOfUse);
              },
              child: Image.asset(
                'assets/images/3.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

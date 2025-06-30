import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'asiudfuhaus/color_asdasjndfj.dart';
import 'asiudfuhaus/onb_rtsdfaksdfmk.dart';
import 'models/challenge.dart';
import 'models/climbing_route.dart';
import 'providers/challenge_provider.dart';
import 'providers/route_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ClimbingRouteAdapter());
  Hive.registerAdapter(ChallengeAdapter());

  await Hive.openBox<ClimbingRoute>('routesBox');
  await Hive.openBox<Challenge>('challengesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Piton Memorize',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colorajsnjf.background,
            ),
            scaffoldBackgroundColor: Colorajsnjf.background,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const OnBoDiasdbvhjdjhasjbdjfh(),
        ),
      ),
    );
  }
}

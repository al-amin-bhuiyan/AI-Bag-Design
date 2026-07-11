import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeebz_bag_design_app/routes/route_path.dart';
import 'package:jeebz_bag_design_app/utils/page_transitions.dart';

import 'dependency/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Binding.init();

  runApp(const MyApp());

   // runApp(
   //   DevicePreview(
   //     enabled: true, // <-- TURN ON DEVICE PREVIEW
   //     builder: (context) => const MyApp(),
   //    ),
   // );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          title: 'AI Bag Design',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme,
          routeInformationParser: RoutePath.router.routeInformationParser,
          routerDelegate: RoutePath.router.routerDelegate,
          routeInformationProvider: RoutePath.router.routeInformationProvider,

          // REQUIRED BY DevicePreview - Chain both builders
          builder: (context, widget) {
            // First apply DevicePreview's builder
            widget = DevicePreview.appBuilder(context, widget);
            // Then apply ScreenUtil's builder if needed
            return widget;
          },
          locale: DevicePreview.locale(context),
        );
      },
    );
  }

  ThemeData get _lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(), // Default font: Poppins
    // Custom page transitions to eliminate white flick during navigation
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.windows: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionPageTransitionsBuilder(),
        TargetPlatform.linux: NoTransitionPageTransitionsBuilder(),
      },
    ),
  );
}

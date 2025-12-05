
import '/screen/splash/splash.dart';
import '/config/global_const.dart';
import '/screen/languege/controller/languege_controller.dart';
import '/util/language_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dependecy_injection.dart' as dependecy_injection;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'service/notification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {

  _hideSystemUI();
  await dependecy_injection.init();
  var permissionNoti = await Permission.notification.status;
  if (permissionNoti.isGranted) {
    await NotificationService.init();
  }
  tz.initializeTimeZones();
  runApp(const MyApp());
}

void _hideSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
    ),
  );

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final languageCtl = Get.find<LanguageController>();
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver: (fontSize, instance) {
        final display = View.of(context).display;
        final screenSize = display.size / display.devicePixelRatio;
        final scaleWidth = screenSize.width / 440;
        return fontSize * scaleWidth;
      },
      builder: (_, child) {
        return GetMaterialApp(
          translations: LanguageUtils(),
          locale: Locale(languageCtl.currentLang.value),
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          title: GlobalConst.kAppName,
          supportedLocales: GlobalConst.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SplashScreen(),
        );
      },
    );
  }
}

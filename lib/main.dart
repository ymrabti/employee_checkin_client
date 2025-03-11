import "dart:io" show Platform;
import "package:flutter/foundation.dart" show PlatformDispatcher, kDebugMode, kIsWeb;
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart" show GlobalCupertinoLocalizations, GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import "package:employee_checks/lib.dart";
import "package:get/get.dart";
import "package:wakelock_plus/wakelock_plus.dart" show WakelockPlus;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }

  // if (kDebugMode) await Future<void>.delayed(Duration(seconds: 5));
  // await EmployeeChecksLocalServices.clearAll();

  Stopwatch stopWatch = Stopwatch()..start();
  Brightness systemBrightness = PlatformDispatcher.instance.platformBrightness;
  await dotenv.load(fileName: '.env');
  String encryptionKey = dotenv.env['ENCRYPT_KEY'] ?? '';
  final SettingsController settingsController = SettingsController();
  await settingsController.loadSettings(encryptionKey: encryptionKey, systemBrightness: systemBrightness);

  EmployeeChecksUser? user = await EmployeeChecksAuthService().getuserConnected(encryptionKey);
  stopWatch.stop();
  logg(stopWatch.elapsedMilliseconds, 'load settings stopwatch');
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: settingsController.isDark ? Brightness.dark : Brightness.light, // iOS
      statusBarIconBrightness: settingsController.isDark ? Brightness.light : Brightness.light, // Android
    ),
  );
  runApp(
    ScreenUtilInit(
      designSize: const Size(360.0, 806.0),
      builder: (BuildContext context, _) {
        return ThemeProvider(
          initTheme: EmployeeChecksTheme(dark: settingsController.isDark),
          duration: const Duration(milliseconds: 300),
          builder: (BuildContext context, ThemeData theme) {
            return ChangeNotifierProvider<EmployeeChecksState>(
              create: (BuildContext context) => EmployeeChecksState(
                settingsController,
                encryptKey: encryptionKey,
                user: user,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 0),
                child: GetMaterialApp(
                  title: 'employee_checks',
                  localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    FormBuilderLocalizations.delegate,
                  ],
                  routes: routes,
                  onUnknownRoute: (RouteSettings settings) {
                    logg(settings.name, 'onUnknownRoute');
                    return MaterialPageRoute<void>(
                      builder: (BuildContext context) => EmployeeChecks_404(),
                    );
                  },
                  unknownRoute: GetPage<void>(
                    name: EmployeeChecks_404.route,
                    page: () {
                      logg('unkown route', 'unkown route');
                      return EmployeeChecks_404();
                    },
                  ),
                  locale: Locale(settingsController.settings.language),
                  supportedLocales: AppLocalizations.supportedLocales,
                  defaultTransition: Transition.cupertino,
                  transitionDuration: Duration(milliseconds: 500),
                  debugShowCheckedModeBanner: false,
                  themeMode: settingsController.isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: EmployeeChecksTheme(dark: settingsController.isDark),
                  darkTheme: EmployeeChecksTheme(dark: settingsController.isDark),
                  popGesture: true,
                  color: settingsController.isDark ? Colors.black87 : Colors.white,
                  //   onGenerateInitialRoutes: (initialRoute) {},
                  //   onGenerateRoute: (settings) {},
                  onGenerateTitle: (BuildContext context) {
                    return context.tr.title;
                  },
                  onDispose: () => logg('GetX Dispose'),
                  onInit: () => logg('GetX Init'),
                  onReady: () => logg('GetX Ready'),
                  //   initialRoute: user == null ? EmployeeChecksGesteLoginScreen.route : EmployeeChecksMainScreen.route,
                  home: EmployeeChecksSplashScreen(
                    dark: settingsController.isDark,
                    user: user,
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

Widget _protectedRoute({
  required BuildContext context,
  required Widget Function(EmployeeChecksUser user) when,
  Widget whenNot = const EmployeeChecks_401(),
}) {
  EmployeeChecksUser? user = context.read<EmployeeChecksState>().user;
  return user == null ? whenNot : when(user);
}

final Map<String, Widget Function(BuildContext context)> routes = <String, Widget Function(BuildContext context)>{
  // PUBLIC
  EmployeeChecksSettingsView.route: (BuildContext context) => EmployeeChecksSettingsView(),
  EmployeeChecksRegisterScreen.route: /**********/ (BuildContext context) => EmployeeChecksRegisterScreen(),
  EmployeeChecksLoginPage.route: (BuildContext context) => EmployeeChecksLoginPage(),
  // EmployeeChecksSplashScreen.route:  (BuildContext context) => EmployeeChecksSplashScreen(),
  // INTERMIEDIATES

  EmployeeChecksOTP_Page.route: (BuildContext context) {
    OTPScreenArguments? arguments = ModalRoute.of(context)?.settings.arguments as OTPScreenArguments?;
    String encryptKey = context.read<EmployeeChecksState>().encryptKey;
    return arguments == null
        ? EmployeeChecks_401()
        : EmployeeChecksOTP_Page(
            arguments: arguments,
            encryptionKey: encryptKey,
          );
  }, // PROTECTED
  EmployeeChecksHomeScreen.route: (BuildContext c) => _protectedRoute(context: c, when: (_) => EmployeeChecksHomeScreen()),
};

import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sembast/sembast.dart';
import 'package:todo_netzlech/gen/fonts.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/todo_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:todo_netzlech/utils/custom_theme_color/custom_theme_color.dart';
import 'package:todo_netzlech/utils/extension.dart';
import 'package:todo_netzlech/utils/localization_manager/localization_manager.dart';
import 'package:todo_netzlech/utils/todo_db/todo_db.dart';
import 'package:todo_netzlech/widget/theme_selection_widget.dart';

Future<void> main() async {
  await configuration(runApp: () async {
    ///final themeMode = await AdaptiveTheme.getThemeMode();
    final todoHelper = TodoHelper(getIt<Database>());
    getIt.registerSingleton(TodoBloc(service: todoHelper), dispose: (param) => param.close());
    runApp(
      BlocProvider(
        create: (context) => getIt<TodoBloc>(),
        child: const Application(mode: AdaptiveThemeMode.light),
      ),
    );
  });
}

class Application extends StatelessWidget {
  const Application({super.key, required this.mode});

  final AdaptiveThemeMode? mode;

  @override
  Widget build(BuildContext context) {
    return LocalizationManager(
      initialLocale: const Locale('en'),
      builder: (locale) => AdaptiveTheme(
        light: ThemeData(
          useMaterial3: true,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: Colors.white,
            headerForegroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 6,
            backgroundColor: Colors.white,
            yearStyle: const TextStyle(color: Colors.black),
            dayStyle: const TextStyle(color: Colors.black),
            rangePickerElevation: 12,
          ),
          fontFamily: FontFamily.rubik,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0XFFFFFFFF),
          primaryColor: const Color(0xFF0560FA),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0560FA),
            primary: const Color(0xFF0560FA),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22), // Rounded corners
            ),
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Color(0xFFF8FBFF),
            backgroundColor: Color(0xFFF8FBFF),
            foregroundColor: Color(0xFFF8FBFF),
            iconTheme: IconThemeData(
              color: Color(0XFF0560FA),
            ),
            titleTextStyle: TextStyle(
              color: Color(0XFF0560FA),
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0XFFDDECFF),
          ),
          dividerColor: const Color(0XFFDDECFF),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0XFF0560FA), // Background color
          ),
          extensions: <ThemeExtension<dynamic>>[
            CustomThemeColor(
              shimmerBaseColor: Colors.grey.shade300,
              shimmerHighlightColor: Colors.grey.shade100,
            ),
          ],
        ),
        initial: mode ?? AdaptiveThemeMode.system,
        builder: (light, dark) => MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          onGenerateTitle: (context) => context.localization.title,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.settings),
      ),
      body: Column(
        children: [
          ListTile(title: Text(context.localization.changeLanguage)),
          const LanguageSelectionWidget(),
          ListTile(title: Text(context.localization.changeTheme)),
          const ThemeSelectionWidget(),
        ],
      ),
    );
  }
}

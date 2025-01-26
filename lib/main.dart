import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sembast/sembast.dart';
import 'package:todo_netzlech/gen/assets.gen.dart';
import 'package:todo_netzlech/gen/fonts.gen.dart';
import 'package:todo_netzlech/injectable/injectable.dart';
import 'package:todo_netzlech/route_config/route_config.dart';
import 'package:todo_netzlech/screen/todo/bloc/pagination_bloc.dart';
import 'package:todo_netzlech/screen/todo/bloc/pagination_state.dart';
import 'package:todo_netzlech/services/firebase/firebase_push_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:todo_netzlech/utils/calender/horizontal_calender.dart';
import 'package:todo_netzlech/utils/custom_theme_color/custom_theme_color.dart';
import 'package:todo_netzlech/utils/extension.dart';
import 'package:todo_netzlech/utils/localization_manager/localization_manager.dart';
import 'package:todo_netzlech/utils/todo_db/todo_db.dart';
import 'package:todo_netzlech/widget/api_builder_widget.dart';
import 'package:todo_netzlech/widget/theme_selection_widget.dart';
import 'package:todo_netzlech/widget/todo_widget/home_title_bar.dart';
import 'widget/todo_widget/task_card.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final notification = FirebasePushHelper.instance;
    notification.initPushConfiguration((value) {});
  }

  final peopleKey = GlobalKey<ApiBuilderWidgetState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.push(TodoRoute.createTodo),
        //onPressed: () => getIt<TodoBloc>().insert(),
        child: Assets.svg.add.svg(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => router.push(TodoRoute.pendingTask),
                  icon: Assets.svg.task.svg(),
                ),
              ],
              forceElevated: innerBoxIsScrolled,
              title: const HomeTitleBar(),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: HorizontalWeekCalendar(
                  onDateChange: (date) => getIt<TodoBloc>().queryForDate(date),
                  inactiveBackgroundColor: const Color(0XFFEEF5FF),
                  inactiveTextColor: const Color(0XFF76B5FF),
                  weekStartFrom: WeekStartFrom.sunday,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  minDate: DateTime(1970),
                  maxDate: DateTime(2050),
                  initialDate: DateTime.now(),
                ),
              ),
            ),
          ];
        },
        body: BlocConsumer<TodoBloc, TodoBlocState>(
          bloc: getIt<TodoBloc>()..fetchTask(),
          buildWhen: (previous, current) => current.task != previous.task,
          builder: (context, state) {
            return state.task.isEmpty
                ? Center(
                    child: Assets.svg.noTask.svg(),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: state.task.map<Widget>((e) => TaskCard(model: e)).toList(),
                  );
          },
          listener: (context, state) {},
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

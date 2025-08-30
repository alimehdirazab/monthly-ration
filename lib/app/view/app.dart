import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_repository/general_repository.dart';
import 'package:grocery_flutter_app/app/cubit/app_cubit.dart';
import 'package:grocery_flutter_app/auth/cubit/auth_cubit.dart';
import 'package:grocery_flutter_app/root/view/view.dart';
import 'package:grocery_flutter_app/splash/view/view.dart';
import 'package:localization/localization.dart';

import '../../utils/utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.generalRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final GeneralRepository generalRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: generalRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppCubit(authenticationRepository)..initializeApp(),
          ),
          BlocProvider(
            create: (_) =>
                AuthCubit(authenticationRepository),
          ),
          // BlocProvider<SettingsCubit>(
          //     create: (context) => SettingsCubit(SettingsRepository(
          //           context.read<GeneralRepository>(),
          //         ))),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.select((AppCubit cubit) => cubit.state);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fox Island",
      navigatorKey: navigatorKey,
      theme: FoxTheme().lightThemeData,
      locale: context.locale,
      supportedLocales: LocalizationSetup.supportedLocales,
      localizationsDelegates: LocalizationSetup.localizationsDelegates,
      localeResolutionCallback: LocalizationSetup.localeResolutionCallback,
      // builder:
      //     (context, child) => MediaQuery(
      //       data: MediaQuery.of(context).copyWith(
      //         textScaler: const TextScaler.linear(1.0),
      //         boldText: false,
      //       ),
      //       child: child!,
      //     ),
      home: _buildPages(appState),
    );
  }

  Widget _buildPages(AppState state) {
    if (state.status == AppStatus.authenticated) {
      return const RootPage();
    } else {
      return const SplashPage();
    }
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_flutter_app/utils/constants/constants.dart';
import 'package:grocery_flutter_app/utils/generics/generics.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(
    this.authenticationRepository, {
    CacheClient? cache,
  })  : cache = cache ?? CacheClient(),
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(
                  authenticationRepository.currentUser,
                  const Locale('en'),
                  true,
                  true,
                  true,
                )
              : const AppState.unauthenticated(
                  Locale('en'),
                  true,
                  true,
                  true,
                ),
        ) {
    userSubscription = authenticationRepository.user.listen(
      (user) => changeAppState(user),
    );
  }

  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<UserAuthentication> userSubscription;
  final CacheClient cache;
  void changeAppState(UserAuthentication user) {
    emit(
      user.isNotEmpty
          ? AppState.authenticated(
              user,
              state.locale,
              state.isDarkTheme,
              state.isMeters,
              state.showOnboarding,
            )
          : AppState.unauthenticated(
              state.locale,
              state.isDarkTheme,
              state.isMeters,
              state.showOnboarding,
            ),
    );
  }

  void initializeApp() {
    final locale = cache.read<String>(key: GroceryKeys.localeCacheKey);
    // fcmService.initializeFcmService();
    final theme = cache.read<bool>(key: GroceryKeys.themeCacheKey);
    final units = cache.read<bool>(key: GroceryKeys.unitsCacheKey);
    // fetchLocation();
    final showOnboarding = cache.read<bool>(key: GroceryKeys.onboardingCacheKey);

    emit(state.copyWith(
      locale: locale == null ? const Locale('en') : Locale(locale),
      isDarkTheme: theme ?? true,
      isMeters: units ?? true,
      showOnboarding: showOnboarding ?? true,
    ));
  }

  void selectEnglishLocale() {
    emit(state.copyWith(locale: const Locale('en')));
    cache.write<String>(key: GroceryKeys.localeCacheKey, value: 'en');
  }

  void changeTheme() {
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
    cache.write<bool>(key: GroceryKeys.themeCacheKey, value: state.isDarkTheme);
  }

  void changeUnits() {
    emit(state.copyWith(isMeters: !state.isMeters));
    cache.write<bool>(key: GroceryKeys.unitsCacheKey, value: state.isMeters);
  }

  void disableOnboarding() {
    emit(state.copyWith(showOnboarding: false));
    cache.write<bool>(key: GroceryKeys.onboardingCacheKey, value: false);
  }

  // void deleteAccount() {
  //   unawaited(authenticationRepository.deleteAccount());
  // }

 

  void logout() {
    unawaited(authenticationRepository.logout());
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }

  //Find day of week
  void checkToday() {
    final now = DateTime.now();

    final dayName = _getDayName(now.weekday);
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    final formattedDate = formatDateDMY(now);
    final formattedTime = formatTime(now);

    emit(state.copyWith(
      dayName: dayName,
      isWeekend: isWeekend,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
    ));

    log("Day: $dayName, Weekend: $isWeekend");
    log("Date: $formattedDate, Time: $formattedTime");
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}

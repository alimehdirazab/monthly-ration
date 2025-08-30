part of 'app_cubit.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = UserAuthentication.empty,
    this.locale = const Locale('en'),
    this.isDarkTheme = true,
    this.isMeters = true,
    this.showOnboarding = true,
    this.isLoading = false,
    this.latitude,
    this.longitude,
    this.error,
    this.dayName = '',
    this.isWeekend = false,
    this.formattedDate = '',
    this.formattedTime = '',
  });

  const AppState.authenticated(
    UserAuthentication user,
    Locale locale,
    bool isDarkTheme,
    bool isMeters,
    bool showOnboarding,
  ) : this._(
          status: AppStatus.authenticated,
          user: user,
          locale: locale,
          isDarkTheme: isDarkTheme,
          isMeters: isMeters,
          showOnboarding: showOnboarding,
        );

  const AppState.unauthenticated(
    Locale locale,
    bool isDarkTheme,
    bool isMeters,
    bool showOnboarding,
  ) : this._(
          status: AppStatus.unauthenticated,
          locale: locale,
          isDarkTheme: isDarkTheme,
          isMeters: isMeters,
          showOnboarding: showOnboarding,
        );

  bool get isAuthenticated => status == AppStatus.authenticated;

  final AppStatus status;
  final UserAuthentication user;
  final Locale locale;
  final bool isDarkTheme;
  final bool isMeters;
  final bool showOnboarding;

  final bool isLoading;
  final double? latitude;
  final double? longitude;
  final String? error;

  //Days of week
  final String dayName;
  final bool isWeekend;

  //Formated Date and Time
  final String formattedDate;
  final String formattedTime;

  AppState copyWith({
    AppStatus? status,
    UserAuthentication? user,
    Locale? locale,
    bool? isDarkTheme,
    bool? isMeters,
    bool? showOnboarding,
    bool? isLoading,
    double? latitude,
    double? longitude,
    String? error,
    String? dayName,
    bool? isWeekend,
    String? formattedDate,
    String? formattedTime,
  }) =>
      AppState._(
        status: status ?? this.status,
        user: user ?? this.user,
        locale: locale ?? this.locale,
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        isMeters: isMeters ?? this.isMeters,
        showOnboarding: showOnboarding ?? this.showOnboarding,
        isLoading: isLoading ?? this.isLoading,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        error: error,
        dayName: dayName ?? this.dayName,
        isWeekend: isWeekend ?? this.isWeekend,
        formattedDate: formattedDate ?? this.formattedDate,
        formattedTime: formattedTime ?? this.formattedTime,
      );

  @override
  List<Object?> get props => [
        status,
        user,
        locale,
        isDarkTheme,
        isMeters,
        showOnboarding,
        isLoading,
        latitude,
        longitude,
        error,
        dayName,
        isWeekend,
        formattedDate,
        formattedTime,
      ];
}

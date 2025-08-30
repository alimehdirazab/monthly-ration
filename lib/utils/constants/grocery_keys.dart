part of 'constants.dart';

class GroceryKeys {
  GroceryKeys._internal();

  static final GroceryKeys _instance = GroceryKeys._internal();

  factory GroceryKeys() {
    return _instance;
  }

  static const String userCacheKey = '__user_cache_key__';
  static const String localeCacheKey = '__locale_cache_key__';
  static const String themeCacheKey = '__theme_cache_key__';
  static const String unitsCacheKey = '__units_cache_key__';
  static const String onboardingCacheKey = '__onboarding_cache_key__';
  static const String oneDriveUsernameKey = '__onedrive_username_key__';
  static const String oneDriveAccessTokenKey = '__onedrive_access_token_key__';
  static const String oneDriveRefreshTokenKey =
      '__onedrive_refresh_token_key__';
  static const String dropboxUsernameKey = 'dropbox_username_key__';
  static const String dropboxAccessTokenKey = '__dropbox_access_token_key__';
  static const String dropboxRefreshTokenKey = '__dropbox_refresh_token_key__';

  static const String pusherAppKey = "39147faca13a5fdfae26";
  static const String pusherCluster = "mt1";
  static const String pusherSecret = "d5eadc98ceeeb03a95d3";

  static const String driveRedirectUri = 'aerial://auth';

  static const String oneDriveClientId = '034c8ff3-1836-47f5-9468-0848bc5c1c20';

  static const String dropboxClientId = 't8hr8wep48yaum8';
  static const String dropboxClientSecret = 'qmvp482kofz46mk';
}

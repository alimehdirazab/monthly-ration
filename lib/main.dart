import 'package:flutter/material.dart';
import 'package:cache/cache.dart';
import 'package:general_repository/general_repository.dart';
import 'package:grocery_flutter_app/app/view/app.dart';
import 'package:grocery_flutter_app/utils/constants/constants.dart';
import 'package:authentication_repository/authentication_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheClient.initializeCache();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 500;
  GroceryApis().initBaseUrlAndAuthEndpoints();

  final generalRepository = GeneralRepository();
  final authenticationRepository = AuthenticationRepository(generalRepository);
  await authenticationRepository.user.first;
  generalRepository.initialize(authenticationRepository);

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      generalRepository: generalRepository,
    ),
  );
}

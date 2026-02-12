import 'package:get_it/get_it.dart';
import 'package:tjwd2d/services/appconfig_service.dart';
import 'package:tjwd2d/services/navigator_service.dart';
import 'package:tjwd2d/services/network_service.dart';
import 'package:tjwd2d/services/token_manager.dart';


GetIt locator = GetIt.instance;

NavigationService get navigationService => locator<NavigationService>();

TokenManager get tokenService => locator<TokenManager>();

void setupLocator() {
  locator.registerLazySingleton(() => NetworkService());
  locator.registerLazySingleton<AppConfigService>(() => AppConfigService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => TokenManager());
}

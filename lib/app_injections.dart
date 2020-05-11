import 'package:get_it/get_it.dart';
import 'package:to_do_mobile_app/shared/data/repositories/setting_repo_service.dart';
import 'package:to_do_mobile_app/shared/data/repositories/to_do_repo_service.dart';

import 'package:to_do_mobile_app/shared/services/app_db_context_service.dart';

final GetIt getIt = GetIt.instance;

class AppInjections {
  static Future<void> setupDI() async {
    final appDbContextService = AppDbContextService();
    // Register services.
    getIt.registerSingletonAsync<AppDbContextService>(() async {
      return appDbContextService;
    });

    // Wait for db initialization.
    await appDbContextService.initDb();
    // await appDbContextService.dropDb();

    getIt.registerSingletonAsync<ToDoRepoService>(() async => ToDoRepoService()); // Use `Lazy` to load when it's needed, but I got error when using `registerLazySingleton`. -> Don't know why.
    getIt.registerSingletonAsync<SettingRepoService>(() async => SettingRepoService());
  }
}
import 'package:get_it/get_it.dart';

import 'package:to_do_mobile_app/shared/services/app_db_context_service.dart';

final GetIt getIt = GetIt.instance;

class AppInjections {
  static Future<void> setupDI() async {
    // Register services.
    getIt.registerSingletonAsync<AppDbContextService>(() async {
      final appDbContextService = AppDbContextService();
      await appDbContextService.initDb();
      // await appDbContextService.dropDb();
      return appDbContextService;
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'core/database/hive_config.dart';
import 'core/locale/locale_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await initHive();
  
  // Inicializar Locale
  await initLocale();

  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
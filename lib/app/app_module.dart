import 'package:flutter_modular/flutter_modular.dart';
import '../modules/reuniao/reuniao_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
    ReuniaoModule(),
  ];

  @override
  void routes(r) {
    r.module('/', module: ReuniaoModule());
  }
}
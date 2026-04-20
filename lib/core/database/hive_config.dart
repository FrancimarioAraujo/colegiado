import 'package:hive_flutter/hive_flutter.dart';
import '../../modules/reuniao/infra/adapters/reuniao_adapter.dart';
import '../../modules/reuniao/infra/adapters/pauta_adapter.dart';
import '../../modules/reuniao/infra/adapters/participante_adapter.dart';
import '../../modules/reuniao/infra/adapters/ata_adapter.dart';
import '../../modules/reuniao/infra/models/reuniao_model.dart';
import '../../modules/reuniao/infra/models/ata_model.dart';

Future<void> initHive() async {
  // Hive.initFlutter() funciona tanto em plataformas nativas quanto em web
  // Em web, usa automaticamente IndexedDB
  await Hive.initFlutter();

  // Registra adapters
  Hive.registerAdapter(ReuniaoAdapter());
  Hive.registerAdapter(PautaAdapter());
  Hive.registerAdapter(ParticipanteAdapter());
  Hive.registerAdapter(AtaAdapter());

  // Abre as caixas com tipos genéricos
  await Hive.openBox<ReuniaoModel>('reunioes');
  await Hive.openBox<AtaModel>('atas');
}
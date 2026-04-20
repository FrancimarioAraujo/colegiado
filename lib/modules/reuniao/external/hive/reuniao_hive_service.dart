import 'package:hive/hive.dart';
import '../../infra/models/reuniao_model.dart';

class ReuniaoHiveService {
  static const String boxName = 'reunioes';

  // Acessa o box diretamente do Hive (já aberto em hive_config.dart)
  Box<ReuniaoModel> get _box => Hive.box<ReuniaoModel>(boxName);

  // ===============================
  // 📌 CREATE
  // ===============================

  Future<void> salvar(ReuniaoModel reuniao) async {
    await _box.add(reuniao);
  }

  // ===============================
  // 📌 READ
  // ===============================

  List<ReuniaoModel> listar() {
    return _box.values.toList();
  }

  ReuniaoModel? buscarPorId(int index) {
    return _box.getAt(index);
  }

  // ===============================
  // 📌 UPDATE
  // ===============================

  Future<void> atualizar(int index, ReuniaoModel reuniao) async {
    await _box.putAt(index, reuniao);
  }

  // ===============================
  // 📌 DELETE
  // ===============================

  Future<void> remover(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> limparTudo() async {
    await _box.clear();
  }

  // ===============================
  // 📌 UTILS
  // ===============================

  bool get isBoxAberta => _box.isOpen;

  int get total => _box.length;
}
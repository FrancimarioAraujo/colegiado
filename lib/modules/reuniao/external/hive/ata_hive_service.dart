import 'package:hive/hive.dart';
import '../../infra/models/ata_model.dart';

class AtaHiveService {
  static const String boxName = 'atas';

  // Acessa o box diretamente do Hive (já aberto em hive_config.dart)
  Box<AtaModel> get _box => Hive.box<AtaModel>(boxName);

  // ===============================
  // 📌 CREATE
  // ===============================

  Future<void> salvar(AtaModel ata) async {
    await _box.add(ata);
  }

  // ===============================
  // 📌 READ
  // ===============================

  List<AtaModel> listar() {
    return _box.values.toList();
  }

  AtaModel? buscarPorId(int index) {
    return _box.getAt(index);
  }

  AtaModel? buscarPorNumeroReuniao(String numeroReuniao) {
    try {
      return _box.values.firstWhere(
        (ata) => ata.reuniaoNumero == numeroReuniao,
      );
    } catch (e) {
      return null;
    }
  }

  // ===============================
  // 📌 UPDATE
  // ===============================

  Future<void> atualizar(int index, AtaModel ata) async {
    await _box.putAt(index, ata);
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

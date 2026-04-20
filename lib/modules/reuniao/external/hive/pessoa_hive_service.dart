import 'package:hive/hive.dart';
import '../../infra/models/pessoa_model.dart';

class PessoaHiveService {
  static const String boxName = 'pessoas';

  // Acessa o box diretamente do Hive (já aberto em hive_config.dart)
  Box<PessoaModel> get _box => Hive.box<PessoaModel>(boxName);

  // ===============================
  // 📌 CREATE
  // ===============================

  Future<void> salvar(PessoaModel pessoa) async {
    await _box.add(pessoa);
  }

  // ===============================
  // 📌 READ
  // ===============================

  List<PessoaModel> listar() {
    return _box.values.toList();
  }

  PessoaModel? buscarPorId(int index) {
    return _box.getAt(index);
  }

  // ===============================
  // 📌 UPDATE
  // ===============================

  Future<void> atualizar(int index, PessoaModel pessoa) async {
    await _box.putAt(index, pessoa);
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
}
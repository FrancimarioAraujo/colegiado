import '../../domain/repositories/ata_repository.dart';
import '../../external/hive/ata_hive_service.dart';
import '../../infra/models/ata_model.dart';

class AtaRepositoryImpl implements AtaRepository {
  final AtaHiveService _hiveService;

  AtaRepositoryImpl(this._hiveService);

  @override
  Future<void> salvar(AtaModel ata) async {
    await _hiveService.salvar(ata);
  }

  @override
  Future<void> atualizar(int index, AtaModel ata) async {
    await _hiveService.atualizar(index, ata);
  }

  @override
  Future<void> remover(int index) async {
    await _hiveService.remover(index);
  }

  @override
  List<AtaModel> listar() {
    return _hiveService.listar();
  }

  @override
  AtaModel? buscarPorId(int id) {
    return _hiveService.buscarPorId(id);
  }

  @override
  AtaModel? buscarPorNumeroReuniao(String numeroReuniao) {
    return _hiveService.buscarPorNumeroReuniao(numeroReuniao);
  }

  @override
  Future<void> limpar() async {
    await _hiveService.limparTudo();
  }
}

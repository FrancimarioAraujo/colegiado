import '../../domain/repositories/reuniao_repository.dart';
import '../../external/hive/reuniao_hive_service.dart';
import '../../infra/models/reuniao_model.dart';

class ReuniaoRepositoryImpl implements ReuniaoRepository {
  final ReuniaoHiveService _hiveService;

  ReuniaoRepositoryImpl(this._hiveService);

  @override
  Future<void> salvar(ReuniaoModel reuniao) async {
    await _hiveService.salvar(reuniao);
  }

  @override
  Future<void> atualizar(int index, ReuniaoModel reuniao) async {
    await _hiveService.atualizar(index, reuniao);
  }

  @override
  Future<void> remover(int index) async {
    await _hiveService.remover(index);
  }

  @override
  List<ReuniaoModel> listar() {
    return _hiveService.listar();
  }

  @override
  ReuniaoModel? buscarPorId(int id) {
    return _hiveService.buscarPorId(id);
  }

  @override
  Future<void> limpar() async {
    await _hiveService.limparTudo();
  }
}

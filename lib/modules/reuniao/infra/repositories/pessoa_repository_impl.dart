import '../../domain/repositories/pessoa_repository.dart';
import '../../infra/models/pessoa_model.dart';
import '../../external/hive/pessoa_hive_service.dart';

class PessoaRepositoryImpl implements PessoaRepository {
  final PessoaHiveService _hiveService;

  PessoaRepositoryImpl(this._hiveService);

  @override
  Future<void> salvar(PessoaModel pessoa) async {
    await _hiveService.salvar(pessoa);
  }

  @override
  Future<void> atualizar(int index, PessoaModel pessoa) async {
    await _hiveService.atualizar(index, pessoa);
  }

  @override
  Future<void> remover(int index) async {
    await _hiveService.remover(index);
  }

  @override
  List<PessoaModel> listar() {
    return _hiveService.listar();
  }

  @override
  PessoaModel? buscarPorId(int id) {
    return _hiveService.buscarPorId(id);
  }

  @override
  Future<void> limpar() async {
    await _hiveService.limparTudo();
  }
}
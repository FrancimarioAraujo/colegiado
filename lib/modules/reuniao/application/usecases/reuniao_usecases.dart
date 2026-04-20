import '../../domain/repositories/reuniao_repository.dart';
import '../../infra/models/reuniao_model.dart';

class ListarReunioesUseCase {
  final ReuniaoRepository _repository;

  ListarReunioesUseCase(this._repository);

  List<ReuniaoModel> call() {
    return _repository.listar();
  }
}

class SalvarReuniaoUseCase {
  final ReuniaoRepository _repository;

  SalvarReuniaoUseCase(this._repository);

  Future<void> call(ReuniaoModel reuniao) async {
    await _repository.salvar(reuniao);
  }
}

class AtualizarReuniaoUseCase {
  final ReuniaoRepository _repository;

  AtualizarReuniaoUseCase(this._repository);

  Future<void> call(int index, ReuniaoModel reuniao) async {
    await _repository.atualizar(index, reuniao);
  }
}

class RemoverReuniaoUseCase {
  final ReuniaoRepository _repository;

  RemoverReuniaoUseCase(this._repository);

  Future<void> call(int index) async {
    await _repository.remover(index);
  }
}

class BuscarReuniaoUseCase {
  final ReuniaoRepository _repository;

  BuscarReuniaoUseCase(this._repository);

  ReuniaoModel? call(int id) {
    return _repository.buscarPorId(id);
  }
}

import '../../domain/repositories/ata_repository.dart';
import '../../infra/models/ata_model.dart';

class ListarAtasUseCase {
  final AtaRepository _repository;

  ListarAtasUseCase(this._repository);

  List<AtaModel> call() {
    return _repository.listar();
  }
}

class SalvarAtaUseCase {
  final AtaRepository _repository;

  SalvarAtaUseCase(this._repository);

  Future<void> call(AtaModel ata) async {
    await _repository.salvar(ata);
  }
}

class AtualizarAtaUseCase {
  final AtaRepository _repository;

  AtualizarAtaUseCase(this._repository);

  Future<void> call(int index, AtaModel ata) async {
    await _repository.atualizar(index, ata);
  }
}

class RemoverAtaUseCase {
  final AtaRepository _repository;

  RemoverAtaUseCase(this._repository);

  Future<void> call(int index) async {
    await _repository.remover(index);
  }
}

class BuscarAtaPorNumeroReuniaoUseCase {
  final AtaRepository _repository;

  BuscarAtaPorNumeroReuniaoUseCase(this._repository);

  AtaModel? call(String numeroReuniao) {
    return _repository.buscarPorNumeroReuniao(numeroReuniao);
  }
}

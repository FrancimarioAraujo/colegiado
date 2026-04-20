import '../../domain/repositories/pessoa_repository.dart';
import '../../infra/models/pessoa_model.dart';

class ListarPessoasUseCase {
  final PessoaRepository _repository;

  ListarPessoasUseCase(this._repository);

  List<PessoaModel> call() {
    return _repository.listar();
  }
}

class SalvarPessoaUseCase {
  final PessoaRepository _repository;

  SalvarPessoaUseCase(this._repository);

  Future<void> call(PessoaModel pessoa) async {
    await _repository.salvar(pessoa);
  }
}

class AtualizarPessoaUseCase {
  final PessoaRepository _repository;

  AtualizarPessoaUseCase(this._repository);

  Future<void> call(int index, PessoaModel pessoa) async {
    await _repository.atualizar(index, pessoa);
  }
}

class RemoverPessoaUseCase {
  final PessoaRepository _repository;

  RemoverPessoaUseCase(this._repository);

  Future<void> call(int index) async {
    await _repository.remover(index);
  }
}

class BuscarPessoaUseCase {
  final PessoaRepository _repository;

  BuscarPessoaUseCase(this._repository);

  PessoaModel? call(int id) {
    return _repository.buscarPorId(id);
  }
}
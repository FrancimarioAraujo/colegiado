import '../../infra/models/pessoa_model.dart';

abstract class PessoaRepository {
  Future<void> salvar(PessoaModel pessoa);
  Future<void> atualizar(int index, PessoaModel pessoa);
  Future<void> remover(int index);
  List<PessoaModel> listar();
  PessoaModel? buscarPorId(int id);
  Future<void> limpar();
}
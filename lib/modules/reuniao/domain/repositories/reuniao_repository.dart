import '../../infra/models/reuniao_model.dart';

abstract class ReuniaoRepository {
  Future<void> salvar(ReuniaoModel reuniao);
  Future<void> atualizar(int index, ReuniaoModel reuniao);
  Future<void> remover(int index);
  List<ReuniaoModel> listar();
  ReuniaoModel? buscarPorId(int id);
  Future<void> limpar();
}

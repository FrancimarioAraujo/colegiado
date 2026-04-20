import '../../infra/models/ata_model.dart';

abstract class AtaRepository {
  Future<void> salvar(AtaModel ata);
  Future<void> atualizar(int index, AtaModel ata);
  Future<void> remover(int index);
  List<AtaModel> listar();
  AtaModel? buscarPorId(int id);
  AtaModel? buscarPorNumeroReuniao(String numeroReuniao);
  Future<void> limpar();
}

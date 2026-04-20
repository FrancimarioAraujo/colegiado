import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class PessoaModel {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final String titulacao; // Prof., Dr., etc.

  @HiveField(2)
  final String? siape;

  @HiveField(3)
  final String? cpf;

  @HiveField(4)
  final DateTime dataInclusao;

  @HiveField(5)
  final DateTime? dataAtualizacao;

  PessoaModel({
    required this.nome,
    required this.titulacao,
    this.siape,
    this.cpf,
    required this.dataInclusao,
    this.dataAtualizacao,
  });

  PessoaModel copyWith({
    String? nome,
    String? titulacao,
    String? siape,
    String? cpf,
    DateTime? dataInclusao,
    DateTime? dataAtualizacao,
  }) {
    return PessoaModel(
      nome: nome ?? this.nome,
      titulacao: titulacao ?? this.titulacao,
      siape: siape ?? this.siape,
      cpf: cpf ?? this.cpf,
      dataInclusao: dataInclusao ?? this.dataInclusao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}


import 'package:hive/hive.dart';
 
@HiveType(typeId: 1)
class PautaModel {
  @HiveField(0)
  final int numero;
  @HiveField(1)
  final String titulo;
  @HiveField(2)
  final String descricao;
  @HiveField(3)
  final String? processoSei;
  @HiveField(4)
  final bool adReferendum;
  @HiveField(5)
  final bool fixado;
  @HiveField(6)
  final String? tipoDefesa;
  @HiveField(7)
  final String? matricula;
  @HiveField(8)
  final String? orientador;
  @HiveField(9)
  final TipoPauta tipoPauta;
  @HiveField(10)
  final String? nomeAluno;
  @HiveField(11)
  final String? professor;

  PautaModel({
    required this.numero,
    required this.titulo,
    required this.descricao,
    this.processoSei,
    this.adReferendum = false,
    this.fixado = false,
    this.tipoDefesa,
    this.matricula,
    this.orientador,
    required this.tipoPauta,
    this.nomeAluno,
    this.professor,
  });

  PautaModel copyWith({
    int? numero,
    String? titulo,
    String? descricao,
    String? processoSei,
    bool? adReferendum,
    bool? fixado,
    String? tipoDefesa,
    String? matricula,
    String? orientador,
    String? nomeAluno,
    required TipoPauta tipoPauta,
    String? professor,
  }) {
    return PautaModel(
      numero: numero ?? this.numero,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      processoSei: processoSei ?? this.processoSei,
      adReferendum: adReferendum ?? this.adReferendum,
      fixado: fixado ?? this.fixado,
      tipoDefesa: tipoDefesa ?? this.tipoDefesa,
      matricula: matricula ?? this.matricula,
      orientador: orientador ?? this.orientador,
      tipoPauta: tipoPauta,
      nomeAluno: nomeAluno ?? this.nomeAluno,
      professor: professor ?? this.professor,
    );
  }
}

enum TipoPauta {
  prorrogacaoPropostaQualificacao,
  prorrogacaoDissertacaoTese,
  diploma,
  interrupcao,
  aproveitamento,
  coorientacao,
  equivalencia
}

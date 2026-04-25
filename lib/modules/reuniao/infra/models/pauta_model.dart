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
  final String? solicitante;
  @HiveField(7)
  final DateTime dataInclusao;
  @HiveField(8)
  final bool adReferendum;
  @HiveField(9)
  final bool fixado;

  PautaModel({
    required this.numero,
    required this.titulo,
    required this.descricao,
    this.processoSei,
    this.solicitante,
   
   
    required this.dataInclusao,
    this.adReferendum = false,
    this.fixado = false,
  });

  PautaModel copyWith({
    int? numero,
    String? titulo,
    String? descricao,
    String? processoSei,
    String? solicitante,
    DateTime? dataInclusao,
    bool? adReferendum,
    bool? fixado,
  }) {
    return PautaModel(
      numero: numero ?? this.numero,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      processoSei: processoSei ?? this.processoSei,
      solicitante: solicitante ?? this.solicitante,
     
      dataInclusao: dataInclusao ?? this.dataInclusao,
      adReferendum: adReferendum ?? this.adReferendum,
      fixado: fixado ?? this.fixado,
    );
  }
}

import 'package:hive/hive.dart';
import 'pauta_model.dart';

@HiveType(typeId: 3)
class AtaModel {
  @HiveField(0)
  final String reuniaoNumero;

  @HiveField(1)
  final DateTime dataReuniao;

  @HiveField(2)
  final String hora;

  @HiveField(3)
  final String local;

  @HiveField(4)
  final List<PautaModel> pautas;

  @HiveField(5)
  final String? observacoes;

  @HiveField(6)
  final String? assinaturasPresentes;

  @HiveField(7)
  final String? assinaturasAusentes;

  @HiveField(8)
  final DateTime dataInclusao;

  @HiveField(9)
  final DateTime? dataAtualizacao;

  @HiveField(10)
  final String? coordenador; // Nome do coordenador que assina a ata

  @HiveField(11)
  final String? secretario; // Nome do secretário que assina a ata

  AtaModel({
    required this.reuniaoNumero,
    required this.dataReuniao,
    required this.hora,
    required this.local,
    required this.pautas,
    this.observacoes,
    this.assinaturasPresentes,
    this.assinaturasAusentes,
    required this.dataInclusao,
    this.dataAtualizacao,
    this.coordenador,
    this.secretario,
  });

  AtaModel copyWith({
    String? reuniaoNumero,
    DateTime? dataReuniao,
    String? hora,
    String? local,
    List<PautaModel>? pautas,
    String? observacoes,
    String? assinaturasPresentes,
    String? assinaturasAusentes,
    DateTime? dataInclusao,
    DateTime? dataAtualizacao,
    String? coordenador,
    String? secretario,
  }) {
    return AtaModel(
      reuniaoNumero: reuniaoNumero ?? this.reuniaoNumero,
      dataReuniao: dataReuniao ?? this.dataReuniao,
      hora: hora ?? this.hora,
      local: local ?? this.local,
      pautas: pautas ?? this.pautas,
      observacoes: observacoes ?? this.observacoes,
      assinaturasPresentes: assinaturasPresentes ?? this.assinaturasPresentes,
      assinaturasAusentes: assinaturasAusentes ?? this.assinaturasAusentes,
      dataInclusao: dataInclusao ?? this.dataInclusao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      coordenador: coordenador ?? this.coordenador,
      secretario: secretario ?? this.secretario,
    );
  }
}

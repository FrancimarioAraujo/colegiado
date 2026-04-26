import 'package:hive/hive.dart';
import 'pauta_model.dart';
import 'participante_model.dart';

enum StatusReuniao { agendada, realizada}

@HiveType(typeId: 0)
class ReuniaoModel {
  @HiveField(0)
  final String numero; // 1ª, 2ª, 3ª, etc.

  @HiveField(1)
  final String tipo; // Ordinária, Extraordinária

  @HiveField(2)
  final DateTime data;

  @HiveField(3)
  final String hora;

  @HiveField(4)
  final String local;

  @HiveField(5)
  final int status; // 0: planejamento, 1: agendada, 2: realizada, 3: cancelada

  @HiveField(6)
  final List<PautaModel> pautas;

  @HiveField(7)
  final List<ParticipanteModel> participantes;

  @HiveField(8)
  final DateTime dataInclusao;

  @HiveField(9)
  final DateTime? dataAtualizacao;

  ReuniaoModel({
    required this.numero,
    required this.tipo,
    required this.data,
    required this.hora,
    required this.local,
    required this.status,
    required this.pautas,
    required this.participantes,
    required this.dataInclusao,
    this.dataAtualizacao,
  });

  StatusReuniao get statusEnum => StatusReuniao.values[status];

  ReuniaoModel copyWith({
    String? numero,
    String? tipo,
    DateTime? data,
    String? hora,
    String? local,
    int? status,
    List<PautaModel>? pautas,
    List<ParticipanteModel>? participantes,
    DateTime? dataInclusao,
    DateTime? dataAtualizacao,
    String? notas,
    bool? temAta,
  }) {
    return ReuniaoModel(
      numero: numero ?? this.numero,
      tipo: tipo ?? this.tipo,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      local: local ?? this.local,
      status: status ?? this.status,
      pautas: pautas ?? this.pautas,
      participantes: participantes ?? this.participantes,
      dataInclusao: dataInclusao ?? this.dataInclusao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}

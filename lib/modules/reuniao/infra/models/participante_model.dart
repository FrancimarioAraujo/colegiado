import 'package:hive/hive.dart';


enum TipoParticipante { presidente, secretario, membro }

@HiveType(typeId: 2)
class ParticipanteModel {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final String titulacao; // Prof., Dr., etc.

  @HiveField(2)
  final int tipo; // 0: presidente, 1: secretario, 2: membro

  @HiveField(3)
  final String? siape;

  @HiveField(4)
  final String? cpf;

  ParticipanteModel({
    required this.nome,
    required this.titulacao,
    required this.tipo,
    this.siape,
    this.cpf,
  });

  TipoParticipante get tipoEnum => TipoParticipante.values[tipo];

  ParticipanteModel copyWith({
    String? nome,
    String? titulacao,
    int? tipo,
    String? siape,
    String? cpf,
  }) {
    return ParticipanteModel(
      nome: nome ?? this.nome,
      titulacao: titulacao ?? this.titulacao,
      tipo: tipo ?? this.tipo,
      siape: siape ?? this.siape,
      cpf: cpf ?? this.cpf,
    );
  }
}

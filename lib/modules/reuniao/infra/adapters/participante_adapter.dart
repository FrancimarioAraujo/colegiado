import 'package:hive/hive.dart';
import '../models/participante_model.dart';

class ParticipanteAdapter extends TypeAdapter<ParticipanteModel> {
  @override
  final int typeId = 2;

  @override
  ParticipanteModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return ParticipanteModel(
      nome: fields[0] as String,
      titulacao: fields[1] as String,
      tipo: fields[2] as int,
      siape: fields[3] as String?,
      cpf: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ParticipanteModel obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.nome);
    writer.writeByte(1);
    writer.write(obj.titulacao);
    writer.writeByte(2);
    writer.write(obj.tipo);
    writer.writeByte(3);
    writer.write(obj.siape);
    writer.writeByte(4);
    writer.write(obj.cpf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipanteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

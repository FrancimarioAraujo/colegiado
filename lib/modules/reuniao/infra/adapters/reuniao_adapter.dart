import 'package:hive/hive.dart';
import '../models/reuniao_model.dart';
import '../models/pauta_model.dart';
import '../models/participante_model.dart';

class ReuniaoAdapter extends TypeAdapter<ReuniaoModel> {
  @override
  final int typeId = 0;

  @override
  ReuniaoModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return ReuniaoModel(
      numero: fields[0] as String,
      tipo: fields[1] as String,
      data: fields[2] as DateTime,
      hora: fields[3] as String,
      local: fields[4] as String,
      status: fields[5] as int,
      pautas: (fields[6] as List).cast<PautaModel>(),
      participantes: (fields[7] as List).cast<ParticipanteModel>(),
      dataInclusao: fields[8] as DateTime,
      dataAtualizacao: fields[9] as DateTime?,
     
    );
  }

  @override
  void write(BinaryWriter writer, ReuniaoModel obj) {
    writer.writeByte(10);
    writer.writeByte(0);
    writer.write(obj.numero);
    writer.writeByte(1);
    writer.write(obj.tipo);
    writer.writeByte(2);
    writer.write(obj.data);
    writer.writeByte(3);
    writer.write(obj.hora);
    writer.writeByte(4);
    writer.write(obj.local);
    writer.writeByte(5);
    writer.write(obj.status);
    writer.writeByte(6);
    writer.write(obj.pautas);
    writer.writeByte(7);
    writer.write(obj.participantes);
    writer.writeByte(8);
    writer.write(obj.dataInclusao);
    writer.writeByte(9);
    writer.write(obj.dataAtualizacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReuniaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
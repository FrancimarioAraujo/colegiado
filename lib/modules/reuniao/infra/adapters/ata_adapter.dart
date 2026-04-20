import 'package:hive/hive.dart';
import '../models/ata_model.dart';
import '../models/pauta_model.dart';

class AtaAdapter extends TypeAdapter<AtaModel> {
  @override
  final int typeId = 3;

  @override
  AtaModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return AtaModel(
      reuniaoNumero: fields[0] as String,
      dataReuniao: fields[1] as DateTime,
      hora: fields[2] as String,
      local: fields[3] as String,
      pautas: (fields[4] as List).cast<PautaModel>(),
      observacoes: fields[5] as String?,
      assinaturasPresentes: fields[6] as String?,
      assinaturasAusentes: fields[7] as String?,
      dataInclusao: fields[8] as DateTime,
      dataAtualizacao: fields[9] as DateTime?,
      coordenador: fields[10] as String?,
      secretario: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AtaModel obj) {
    writer.writeByte(12);
    writer.writeByte(0);
    writer.write(obj.reuniaoNumero);
    writer.writeByte(1);
    writer.write(obj.dataReuniao);
    writer.writeByte(2);
    writer.write(obj.hora);
    writer.writeByte(3);
    writer.write(obj.local);
    writer.writeByte(4);
    writer.write(obj.pautas);
    writer.writeByte(5);
    writer.write(obj.observacoes);
    writer.writeByte(6);
    writer.write(obj.assinaturasPresentes);
    writer.writeByte(7);
    writer.write(obj.assinaturasAusentes);
    writer.writeByte(8);
    writer.write(obj.dataInclusao);
    writer.writeByte(9);
    writer.write(obj.dataAtualizacao);
    writer.writeByte(10);
    writer.write(obj.coordenador);
    writer.writeByte(11);
    writer.write(obj.secretario);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

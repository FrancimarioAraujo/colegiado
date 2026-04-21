import 'package:hive/hive.dart';
import '../models/pauta_model.dart';

class PautaAdapter extends TypeAdapter<PautaModel> {
  @override
  final int typeId = 1;

  @override
  PautaModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return PautaModel(
      numero: fields[0] as int,
      titulo: fields[1] as String,
      descricao: fields[2] as String,
      processoSei: fields[3] as String?,
      solicitante: fields[4] as String?,
      relator: fields[5] as String?,
      decisao: fields[6] as String?,
      dataInclusao: fields[7] as DateTime,
      adReferendum: fields[8] as bool? ?? false,
      fixado: fields[9] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, PautaModel obj) {
    writer.writeByte(10);
    writer.writeByte(0);
    writer.write(obj.numero);
    writer.writeByte(1);
    writer.write(obj.titulo);
    writer.writeByte(2);
    writer.write(obj.descricao);
    writer.writeByte(3);
    writer.write(obj.processoSei);
    writer.writeByte(4);
    writer.write(obj.solicitante);
    writer.writeByte(5);
    writer.write(obj.relator);
    writer.writeByte(6);
    writer.write(obj.decisao);
    writer.writeByte(7);
    writer.write(obj.dataInclusao);

    writer.writeByte(8);
    writer.write(obj.adReferendum);

    writer.writeByte(9);
    writer.write(obj.fixado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PautaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
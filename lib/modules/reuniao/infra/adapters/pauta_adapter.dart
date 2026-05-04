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
      adReferendum: fields[4] as bool? ?? false,
      fixado: fields[5] as bool? ?? false,
      tipoDefesa: fields[6] as String?,
      matricula: fields[7] as String?,
      orientador: fields[8] as String?, 
      tipoPauta: fields[9] as TipoPauta,
      nomeAluno: fields[10] as String?,
      professor: fields[11] as String?,
      relator: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PautaModel obj) {
    writer.writeByte(13);
    writer.writeByte(0);
    writer.write(obj.numero);
    writer.writeByte(1);
    writer.write(obj.titulo);
    writer.writeByte(2);
    writer.write(obj.descricao);
    writer.writeByte(3);
    writer.write(obj.processoSei);
    writer.writeByte(4);
    writer.write(obj.adReferendum);
    writer.writeByte(5);
    writer.write(obj.fixado);
    writer.writeByte(6);
    writer.write(obj.tipoDefesa);
    writer.writeByte(7);
    writer.write(obj.matricula);
    writer.writeByte(8);
    writer.write(obj.orientador);
    writer.writeByte(9);
    writer.write(obj.tipoPauta);
    writer.writeByte(10);
    writer.write(obj.nomeAluno);
    writer.writeByte(11);
    writer.write(obj.professor);
    writer.writeByte(12);
    writer.write(obj.relator);
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
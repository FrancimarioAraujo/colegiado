import 'package:hive/hive.dart';
import '../models/pessoa_model.dart';

class PessoaAdapter extends TypeAdapter<PessoaModel> {
  @override
  final int typeId = 4;

  @override
  PessoaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return PessoaModel(
      nome: fields[0] as String,
      titulacao: fields[1] as String,
      siape: fields[2] as String?,
      cpf: fields[3] as String?,
      dataInclusao: fields[4] as DateTime,
      dataAtualizacao: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PessoaModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.titulacao)
      ..writeByte(2)
      ..write(obj.siape)
      ..writeByte(3)
      ..write(obj.cpf)
      ..writeByte(4)
      ..write(obj.dataInclusao)
      ..writeByte(5)
      ..write(obj.dataAtualizacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PessoaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
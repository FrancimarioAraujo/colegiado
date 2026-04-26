import 'package:hive/hive.dart';
import '../models/pauta_model.dart';

class TipoPautaAdapter extends TypeAdapter<TipoPauta> {
  @override
  final int typeId = 5;

  @override
  TipoPauta read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoPauta.outra;
      case 1:
        return TipoPauta.prorrogacaoPropostaQualificacao;
      case 2:
        return TipoPauta.prorrogacaoDissertacaoTese;
      case 3:
        return TipoPauta.diploma;
      case 4:
        return TipoPauta.interrupcao;
      case 5:
        return TipoPauta.aproveitamento;
      case 6:
        return TipoPauta.coorientacao;
      case 7:
        return TipoPauta.equivalencia;
      default:
        return TipoPauta.outra;
    }
  }

  @override
  void write(BinaryWriter writer, TipoPauta obj) {
    switch (obj) {
      case TipoPauta.outra:
        writer.writeByte(0);
        break;
      case TipoPauta.prorrogacaoPropostaQualificacao:
        writer.writeByte(1);
        break;
      case TipoPauta.prorrogacaoDissertacaoTese:
        writer.writeByte(2);
        break;
      case TipoPauta.diploma:
        writer.writeByte(3);
        break;
      case TipoPauta.interrupcao:
        writer.writeByte(4);
        break;
      case TipoPauta.aproveitamento:
        writer.writeByte(5);
        break;
      case TipoPauta.coorientacao:
        writer.writeByte(6);
        break;
      case TipoPauta.equivalencia:
        writer.writeByte(7);
        break;
    }
  }
}
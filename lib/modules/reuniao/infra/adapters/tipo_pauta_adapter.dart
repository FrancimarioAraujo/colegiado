import 'package:hive/hive.dart';
import '../models/pauta_model.dart';

class TipoPautaAdapter extends TypeAdapter<TipoPauta> {
  @override
  final int typeId = 5;

  @override
  TipoPauta read(BinaryReader reader) {
    switch (reader.readByte()) {
      
      case 0:
        return TipoPauta.prorrogacaoPropostaQualificacao;
      case 1:
        return TipoPauta.prorrogacaoDissertacaoTese;
      case 2:
        return TipoPauta.diploma;
      case 3:
        return TipoPauta.interrupcao;
      case 4:
        return TipoPauta.aproveitamento;
      case 5:
        return TipoPauta.coorientacao;
      case 6:
        return TipoPauta.equivalencia;
      default:
        return TipoPauta.prorrogacaoPropostaQualificacao;
    }
  }

  @override
  void write(BinaryWriter writer, TipoPauta obj) {
    switch (obj) {
   
      case TipoPauta.prorrogacaoPropostaQualificacao:
        writer.writeByte(0);
        break;
      case TipoPauta.prorrogacaoDissertacaoTese:
        writer.writeByte(1);
        break;
      case TipoPauta.diploma:
        writer.writeByte(2);
        break;
      case TipoPauta.interrupcao:
        writer.writeByte(3);
        break;
      case TipoPauta.aproveitamento:
        writer.writeByte(4);
        break;
      case TipoPauta.coorientacao:
        writer.writeByte(5);
        break;
      case TipoPauta.equivalencia:
        writer.writeByte(6);
        break;
    }
  }
}
import 'pauta.dart';

class Reuniao {
  int numero;
  String tipo;
  DateTime data;
  String hora;
  String local;
  String presidente;
  String secretario;
  List<Pauta> pautas;

  Reuniao({
    required this.numero,
    required this.tipo,
    required this.data,
    required this.hora,
    required this.local,
    required this.presidente,
    required this.secretario,
    required this.pautas,
  });
}
class Pauta {
  int numero;
  String titulo;
  String descricao;
  String status;
  bool adReferendum;
  bool fixado;

  Pauta({
    required this.numero,
    required this.titulo,
    required this.descricao,
    this.status = "Pendente",
    this.adReferendum = false,
    this.fixado = false,
  });
}
class Pauta {
  int numero;
  String titulo;
  String descricao;
  String status;

  Pauta({
    required this.numero,
    required this.titulo,
    required this.descricao,
    this.status = "Pendente",
  });
}
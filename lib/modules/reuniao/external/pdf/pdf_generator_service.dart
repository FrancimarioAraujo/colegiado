import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/ata_model.dart';
import '../../../../core/locale/date_formatter.dart';

class PdfGeneratorService {
  static const String universidade = 'UNIVERSIDADE FEDERAL DE CAMPINA GRANDE';
  static const String programa = 'PÓS-GRADUAÇÃO EM ENGENHARIA ELÉTRICA';
  static const String endereco =
      'Rua Aprígio Veloso, 882, - Bairro Universitário, Campina Grande/PB, CEP 58429-900';
  static const String ministerio = 'MINISTÉRIO DA EDUCAÇÃO';

  // ===============================
  // 📌 GERAR CONVOCAÇÃO
  // ===============================

  pw.Document gerarConvocacao(ReuniaoModel reuniao) {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Cabeçalho
              pw.Text(
                ministerio,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                universidade,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                programa,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                endereco,
                style: pw.TextStyle(
                  fontSize: 9,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Título
              pw.Text(
                'CONVOCAÇÃO',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),

              // Corpo
              pw.Paragraph(
                text:
                    'Convocamos Vossa Senhoria para a ${reuniao.numero} Reunião ${reuniao.tipo} do Colegiado do Programa de Pós-Graduação em Engenharia Elétrica, a realizar-se no dia ${DateFormatter.formatDateLong(reuniao.data)}, às ${reuniao.hora}, em ${reuniao.local}.',
                style: pw.TextStyle(fontSize: 11, height: 1.5),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 20),

              // Pautas
              pw.Text(
                'PAUTA',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...reuniao.pautas.map((pauta) {
                return pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${pauta.numero}. ${pauta.titulo}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      if (pauta.descricao.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          pauta.descricao,
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                      if (pauta.processoSei != null &&
                          pauta.processoSei!.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Processo SEI: ${pauta.processoSei}',
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),

              pw.Spacer(),

              // Rodapé
              pw.SizedBox(height: 30),
              pw.Text(
                'Campina Grande, ${DateFormatter.formatDateLong(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                '_______________________________',
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'Coordenador do PPgEE',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  // ===============================
  // 📌 GERAR ATA
  // ===============================

  pw.Document gerarAta(AtaModel ata) {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Cabeçalho
              pw.Text(
                ministerio,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                universidade,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                programa,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                endereco,
                style: pw.TextStyle(
                  fontSize: 9,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Título
              pw.Text(
                'ATA DA ${ata.reuniaoNumero} REUNIÃO ORDINÁRIA DO COLEGIADO',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 15),

              // Informações da Reunião
              pw.Text(
                'INFORMAÇÕES GERAIS',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Paragraph(
                text:
                    'Data: ${DateFormatter.formatDateLong(ata.dataReuniao)}\nHora: ${ata.hora}\nLocal: ${ata.local}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 15),

              // Pautas discutidas
              pw.Text(
                'PAUTAS DISCUTIDAS E DECISÕES',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...ata.pautas.map((pauta) {
                return pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${pauta.numero}. ${pauta.titulo}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      if (pauta.descricao.isNotEmpty) ...[
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Descrição: ${pauta.descricao}',
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                      if (pauta.solicitante != null &&
                          pauta.solicitante!.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Solicitante: ${pauta.solicitante}',
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                      if (pauta.relator != null && pauta.relator!.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Relator: ${pauta.relator}',
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                      if (pauta.decisao != null && pauta.decisao!.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Decisão: ${pauta.decisao}',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),

              if (ata.observacoes != null && ata.observacoes!.isNotEmpty) ...[
                pw.SizedBox(height: 15),
                pw.Text(
                  'OBSERVAÇÕES',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Paragraph(
                  text: ata.observacoes!,
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.justify,
                ),
              ],

              pw.Spacer(),

              // Assinaturas
              pw.SizedBox(height: 20),
              pw.Text(
                'Campina Grande, ${DateFormatter.formatDateLong(ata.dataReuniao)}',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    children: [
                      pw.SizedBox(height: 40),
                      pw.Text(
                        '_______________________________',
                      ),
                      if (ata.secretario != null && ata.secretario!.isNotEmpty)
                        pw.Text(
                          ata.secretario!,
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.center,
                        ),
                      pw.Text(
                        'Secretário',
                        style: pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.SizedBox(height: 40),
                      pw.Text(
                        '_______________________________',
                      ),
                      if (ata.coordenador != null && ata.coordenador!.isNotEmpty)
                        pw.Text(
                          ata.coordenador!,
                          style: pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.center,
                        ),
                      pw.Text(
                        'Coordenador do PPgEE',
                        style: pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }
}

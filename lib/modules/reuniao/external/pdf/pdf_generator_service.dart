import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/ata_model.dart';
import '../../../../core/locale/date_formatter.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfGeneratorService {
  static const String universidade =
      'UNIVERSIDADE FEDERAL DE CAMPINA GRANDE';
  static const String programa =
      'PÓS-GRADUAÇÃO EM ENGENHARIA ELÉTRICA';
  static const String endereco =
      'Rua Aprígio Veloso, 882 - Bairro Universitário, Campina Grande/PB, CEP 58429-900';
  static const String ministerio = 'MINISTÉRIO DA EDUCAÇÃO';

  // ===============================
  // 🎨 ESTILOS
  // ===============================
  pw.TextStyle get _base =>
      pw.TextStyle(fontSize: 11, lineSpacing: 3);

  pw.TextStyle get _bold =>
      pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);

  pw.TextStyle get _title =>
      pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);

  pw.TextStyle get _header =>
      pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);

  // ===============================
  // 🧱 HEADER
  // ===============================
  pw.Widget _buildHeader(pw.Image image) {
    return pw.Column(
      children: [
        image,
        pw.SizedBox(height: 4),
        pw.Text(ministerio, style: pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 4),
        pw.Text(universidade, style: _header, textAlign: pw.TextAlign.center),
        pw.Text(programa,
            style: pw.TextStyle(fontSize: 11),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 4),
        pw.Text(endereco,
            style: pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 10),
      ],
    );
  }

  // ===============================
  // 📌 CONVOCAÇÃO
  // ===============================
  Future<pw.Document> gerarConvocacao(ReuniaoModel reuniao) async {
    final imageBytes = await rootBundle.load('assets/images/brasao.png');
    final image = pw.Image(
      pw.MemoryImage(imageBytes.buffer.asUint8List()),
      width: 50,
      height: 50,
    );

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(60, 80, 60, 60),

        // ✅ Cabeçalho apenas na primeira página
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.Center(child: _buildHeader(image));
          }
          return pw.SizedBox();
        },

        // ✅ Rodapé
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 9),
          ),
        ),

        build: (context) => [
          pw.SizedBox(height: 20),

          pw.Center(
            child: pw.Text(
              'CONVOCAÇÃO',
              style: _title.copyWith(letterSpacing: 1),
            ),
          ),

          pw.SizedBox(height: 25),

          pw.RichText(
            text: pw.TextSpan(
              style: _base,
              children: [
                pw.TextSpan(
                  text:
                      'Convocamos Vossa Senhoria para a ${reuniao.numero} Reunião ${reuniao.tipo} do Colegiado do Programa de Pós-Graduação em Engenharia Elétrica, a realizar-se no dia ',
                ),
                pw.TextSpan(
                  text: DateFormatter.formatDateLong(reuniao.data),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.TextSpan(text: ', às '),
                pw.TextSpan(
                  text: "${reuniao.hora} horas",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.TextSpan(
                  text: ', em ${reuniao.local}.',
                ),
              ],
            ),
            textAlign: pw.TextAlign.justify,
          ),

          pw.SizedBox(height: 15),

          // 🔹 LISTA DE PAUTAS
          ...reuniao.pautas.map((pauta) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.RichText(
                text: pw.TextSpan(
                  style: _base,
                  children: [
                    pw.TextSpan(
                      text: '${pauta.numero}. ',
                      style: _bold,
                    ),
                    pw.TextSpan(
                      text: pauta.titulo,
                      style: _bold,
                    ),

                    if (pauta.processoSei != null &&
                        pauta.processoSei!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.processoSei!,
                            style: pw.TextStyle(
                              color: PdfColor(0, 0, 0.5),
                              decoration: pw.TextDecoration.underline,
                              fontWeight: pw.FontWeight.bold,
                              fontStyle: pw.FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                    if (pauta.descricao.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ${pauta.descricao}'),
                          if (pauta.adReferendum == true)
                            pw.TextSpan(
                              text: ' (Aprovado Ad Referendum)',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold),
                            ),
                        ],
                      ),
                  ],
                ),
                textAlign: pw.TextAlign.justify,
              ),
            );
          }).toList(),

          pw.SizedBox(height: 30),

          pw.Center(
            child: pw.Text(
              'Campina Grande, ${DateFormatter.formatDateLong(DateTime.now())}',
              style: _base,
            ),
          ),

          pw.SizedBox(height: 40),

          pw.Center(child: pw.Text('__________________________________')),
          pw.Center(
            child: pw.Text(
              'Coordenador do PPgEE',
              style: pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return doc;
  }

  // ===============================
  // 📌 ATA
  // ===============================
  Future<pw.Document> gerarAta(AtaModel ata) async {
    final imageBytes = await rootBundle.load('assets/images/brasao.png');
    final image = pw.Image(
      pw.MemoryImage(imageBytes.buffer.asUint8List()),
      width: 50,
      height: 50,
    );

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(60, 80, 60, 60),

        // ✅ Cabeçalho só na primeira página
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.Center(child: _buildHeader(image));
          }
          return pw.SizedBox();
        },

        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 9),
          ),
        ),

        build: (context) => [
          pw.SizedBox(height: 20),

          pw.Center(
            child: pw.Text(
              'ATA DA ${ata.reuniaoNumero}ª REUNIÃO ORDINÁRIA DO COLEGIADO',
              style: _bold,
              textAlign: pw.TextAlign.center,
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Paragraph(
            text:
                'Aos ${DateFormatter.formatDateLong(ata.dataReuniao)}, às ${ata.hora}, em ${ata.local}, realizou-se a reunião do colegiado...',
            style: _base,
            textAlign: pw.TextAlign.justify,
          ),

          pw.SizedBox(height: 15),

          ...ata.pautas.map((pauta) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.RichText(
                text: pw.TextSpan(
                  style: _base,
                  children: [
                    pw.TextSpan(
                      text: '${pauta.numero}. ',
                      style: _bold,
                    ),
                    pw.TextSpan(
                      text: pauta.titulo +
                          (pauta.adReferendum == true
                              ? ' (Ad referendum)'
                              : ''),
                      style: _bold,
                    ),
                    if (pauta.decisao != null)
                      pw.TextSpan(
                        text: ' - ${pauta.decisao}',
                      ),
                  ],
                ),
              ),
            );
          }).toList(),

          pw.SizedBox(height: 30),

          pw.Center(
            child: pw.Text(
              'Campina Grande, ${DateFormatter.formatDateLong(ata.dataReuniao)}',
              style: _base,
            ),
          ),

          pw.SizedBox(height: 40),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _assinatura(ata.secretario, 'Secretário'),
              _assinatura(ata.coordenador, 'Coordenador'),
            ],
          ),
        ],
      ),
    );

    return doc;
  }

  // ===============================
  // ✍️ ASSINATURA
  // ===============================
  pw.Widget _assinatura(String? nome, String cargo) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 40),
        pw.Text('_______________________________'),
        if (nome != null && nome.isNotEmpty)
          pw.Text(
            nome,
            style: pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
        pw.Text(
          cargo,
          style: pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }
}
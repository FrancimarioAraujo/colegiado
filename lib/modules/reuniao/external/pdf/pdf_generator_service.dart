import 'package:colegiado/modules/reuniao/infra/models/pauta_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../infra/models/reuniao_model.dart';
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
                      'Convocamos Vossa Senhoria para a ${reuniao.numero}ª Reunião ${reuniao.tipo} do Colegiado do Programa de Pós-Graduação em Engenharia Elétrica, a realizar-se no dia ',
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
            if(pauta.tipoPauta == TipoPauta.prorrogacaoPropostaQualificacao){
              return gerarPautaProrrogacaoDefesa(pauta);
            }
            if(pauta.tipoPauta == TipoPauta.prorrogacaoDissertacaoTese){
              return gerarPautaProrrogacaoDissertacaoTese(pauta);
            }
            if(pauta.tipoPauta == TipoPauta.interrupcao){
              return gerarPautaInterrupcao(pauta);
            }
            return gerarOutraPauta(pauta);
          }).toList(),

          pw.SizedBox(height: 30),

          pw.Center(
            child: pw.Text(
              'Campina Grande, ${DateFormatter.formatDateLong(DateTime.now())}',
              style: _base,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Center(child: pw.Text('Eisenhawer de Moura Fernandes', style: _base)),
           pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              'Coordenador do PPgEE',
              style: _base,
            ),
          ),
        ],
      ),
    );

    return doc;
  } 

  pw.Padding gerarOutraPauta(PautaModel pauta){
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
  }

  pw.Padding gerarPautaInterrupcao(PautaModel pauta){
   return  pw.Padding(
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
      if(pauta.nomeAluno != null && pauta.nomeAluno!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.nomeAluno!.toUpperCase(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,

                            ),
                          ),
                        ],
                      ),

                       
                    if (pauta.matricula != null && pauta.matricula!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.matricula!,
                        
                          ),
                        ],
                      ),

                      if (pauta.orientador != null && pauta.orientador!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.orientador!,
                          
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
  }

   pw.Padding gerarPautaProrrogacaoDissertacaoTese(PautaModel pauta){
   return  pw.Padding(
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
      if(pauta.nomeAluno != null && pauta.nomeAluno!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.nomeAluno!.toUpperCase(),
                        
                          ),
                        ],
                      ),

                       
                    if (pauta.matricula != null && pauta.matricula!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.matricula!,
                        
                          ),
                        ],
                      ),

                      if (pauta.orientador != null && pauta.orientador!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.orientador!,
                          
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
  }
  

  pw.Padding gerarPautaProrrogacaoDefesa(PautaModel pauta){
   return  pw.Padding(
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

                    if (pauta.matricula != null && pauta.matricula!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.matricula!,
                        
                          ),
                        ],
                      ),

                      if (pauta.orientador != null && pauta.orientador!.isNotEmpty)
                      pw.TextSpan(
                        children: [
                          pw.TextSpan(text: ' - ', style: _bold),
                          pw.TextSpan(
                            text: pauta.orientador!,
                          
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
  }
}
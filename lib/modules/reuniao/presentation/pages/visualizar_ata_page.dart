import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../external/pdf/pdf_generator_service.dart';
import '../../infra/models/ata_model.dart';

class VisualizarAtaPage extends StatefulWidget {
  final int ataId;

  const VisualizarAtaPage({Key? key, required this.ataId}) : super(key: key);

  @override
  State<VisualizarAtaPage> createState() => _VisualizarAtaPageState();
}

class _VisualizarAtaPageState extends State<VisualizarAtaPage> {
  late final PdfGeneratorService _pdfGeneratorService;

  AtaModel? _ata;

  @override
  void initState() {
    super.initState();
    // Aqui você poderia buscar por ID se implementar esse método no repositório
    // Por enquanto, será necessário ajustar conforme necessário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ata'),
        centerTitle: true,
        actions: [
          if (_ata != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _imprimirOuCompartilhar,
            ),
        ],
      ),
      body: _ata == null
          ? const Center(
              child: Text('Ata não encontrada'),
            )
          : PdfPreview(
              build: (format) =>
                  _pdfGeneratorService.gerarAta(_ata!).save(),
              canDebug: false,
            ),
    );
  }

  Future<void> _imprimirOuCompartilhar() async {
    if (_ata == null) return;

    final pdf = _pdfGeneratorService.gerarAta(_ata!);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'ata_${_ata!.reuniaoNumero}_${DateTime.now().toString().split(' ')[0]}.pdf',
    );
  }
}

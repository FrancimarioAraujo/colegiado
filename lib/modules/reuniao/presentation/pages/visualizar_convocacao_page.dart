import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../external/pdf/pdf_generator_service.dart';
import '../../infra/models/reuniao_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VisualizarConvocacaoPage extends StatefulWidget {
  final int reuniaoId;

  const VisualizarConvocacaoPage({Key? key, required this.reuniaoId})
      : super(key: key);

  @override
  State<VisualizarConvocacaoPage> createState() =>
      _VisualizarConvocacaoPageState();
}

class _VisualizarConvocacaoPageState extends State<VisualizarConvocacaoPage> {
  late final BuscarReuniaoUseCase _buscarReuniaoUseCase;
  late final PdfGeneratorService _pdfGeneratorService;

  ReuniaoModel? _reuniao;

  @override
  void initState() {
    super.initState();
    _buscarReuniaoUseCase = Modular.get<BuscarReuniaoUseCase>();
    _pdfGeneratorService = Modular.get<PdfGeneratorService>();
    _reuniao = _buscarReuniaoUseCase(widget.reuniaoId);
  }

  @override
  Widget build(BuildContext context) {
    if (_reuniao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Convocação')),
        body: const Center(
          child: Text('Reunião não encontrada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convocação'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _imprimirOuCompartilhar,
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async {
          final doc = await _pdfGeneratorService.gerarConvocacao(_reuniao!);
          return doc.save();
        },
        canDebug: false,
      ),
    );
  }

  Future<void> _imprimirOuCompartilhar() async {
    final pdf = await _pdfGeneratorService.gerarConvocacao(_reuniao!);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'convocacao_${_reuniao!.numero}_${DateTime.now().toString().split(' ')[0]}.pdf',
    );
  }
}

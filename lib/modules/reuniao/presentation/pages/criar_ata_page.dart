import 'package:flutter/material.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../application/usecases/ata_usecases.dart';
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/ata_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CriarAtaPage extends StatefulWidget {
  final int reuniaoId;

  const CriarAtaPage({Key? key, required this.reuniaoId}) : super(key: key);

  @override
  State<CriarAtaPage> createState() => _CriarAtaPageState();
}

class _CriarAtaPageState extends State<CriarAtaPage> {
  final _formKey = GlobalKey<FormState>();
  late final BuscarReuniaoUseCase _buscarReuniaoUseCase;
  late final AtualizarReuniaoUseCase _atualizarReuniaoUseCase;
  late final SalvarAtaUseCase _salvarAtaUseCase;

  final _observacoesController = TextEditingController();
  final _coordenadorController = TextEditingController();
  final _secretarioController = TextEditingController();
  final _assinaturasApresentesController = TextEditingController();
  final _assinaturasAusentesController = TextEditingController();

  ReuniaoModel? _reuniao;

  @override
  void initState() {
    super.initState();
    _buscarReuniaoUseCase = Modular.get<BuscarReuniaoUseCase>();
    _atualizarReuniaoUseCase = Modular.get<AtualizarReuniaoUseCase>();
    _salvarAtaUseCase = Modular.get<SalvarAtaUseCase>();
    _reuniao = _buscarReuniaoUseCase(widget.reuniaoId);
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    _coordenadorController.dispose();
    _secretarioController.dispose();
    _assinaturasApresentesController.dispose();
    _assinaturasAusentesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reuniao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Criar Ata')),
        body: const Center(
          child: Text('Reunião não encontrada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Ata'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reunião: ${_reuniao!.numero} ${_reuniao!.tipo}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Pautas: ${_reuniao!.pautas.length}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _coordenadorController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Coordenador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _secretarioController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Secretário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _assinaturasApresentesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Participantes Presentes (opcional)',
                  hintText: 'Digite os nomes separados por vírgula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _assinaturasAusentesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Participantes Ausentes (opcional)',
                  hintText: 'Digite os nomes separados por vírgula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _observacoesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _salvarAta();
                        }
                      },
                      child: const Text('Criar Ata'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      onPressed: () => Modular.to.pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarAta() async {
    final ata = AtaModel(
      reuniaoNumero: _reuniao!.numero,
      dataReuniao: _reuniao!.data,
      hora: _reuniao!.hora,
      local: _reuniao!.local,
      pautas: _reuniao!.pautas,
      observacoes: _observacoesController.text.isEmpty
          ? null
          : _observacoesController.text,
      assinaturasPresentes: _assinaturasApresentesController.text.isEmpty
          ? null
          : _assinaturasApresentesController.text,
      assinaturasAusentes: _assinaturasAusentesController.text.isEmpty
          ? null
          : _assinaturasAusentesController.text,
      dataInclusao: DateTime.now(),
      coordenador: _coordenadorController.text.isEmpty
          ? null
          : _coordenadorController.text,
      secretario: _secretarioController.text.isEmpty
          ? null
          : _secretarioController.text,
    );

    await _salvarAtaUseCase(ata);

    // Atualizar reunião para indicar que tem ata
    final reuniaoAtualizada = _reuniao!.copyWith(temAta: true);
    await _atualizarReuniaoUseCase(widget.reuniaoId, reuniaoAtualizada);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ata criada com sucesso'),
        ),
      );
      Modular.to.pop();
    }
  }
}

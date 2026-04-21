import 'package:flutter/material.dart';
import '../../application/usecases/reuniao_usecases.dart';
import '../../infra/models/reuniao_model.dart';
import '../../infra/models/pauta_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CriarPautaPage extends StatefulWidget {
  final int reuniaoId;

  const CriarPautaPage({Key? key, required this.reuniaoId}) : super(key: key);

  @override
  State<CriarPautaPage> createState() => _CriarPautaPageState();
}

class _CriarPautaPageState extends State<CriarPautaPage> {
  final _formKey = GlobalKey<FormState>();
  late final BuscarReuniaoUseCase _buscarReuniaoUseCase;
  late final AtualizarReuniaoUseCase _atualizarReuniaoUseCase;

  final _numeroController = TextEditingController();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _processoSeiController = TextEditingController();
  final _solicitanteController = TextEditingController();
  final _relatorController = TextEditingController();
  final _decisaoController = TextEditingController();

  bool _adReferendum = false;
  bool _fixado = false;

  ReuniaoModel? _reuniao;

  @override
  void initState() {
    super.initState();
    _buscarReuniaoUseCase = Modular.get<BuscarReuniaoUseCase>();
    _atualizarReuniaoUseCase = Modular.get<AtualizarReuniaoUseCase>();
    _reuniao = _buscarReuniaoUseCase(widget.reuniaoId);

    // Auto-complete o número da pauta
    if (_reuniao != null) {
      _numeroController.text = '${_reuniao!.pautas.length + 1}';
    }
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _processoSeiController.dispose();
    _solicitanteController.dispose();
    _relatorController.dispose();
    _decisaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reuniao == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Adicionar Pauta')),
        body: const Center(child: Text('Reunião não encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Pauta'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número da Pauta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _processoSeiController,
                decoration: const InputDecoration(
                  labelText: 'Processo SEI (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _solicitanteController,
                decoration: const InputDecoration(
                  labelText: 'Solicitante (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _relatorController,
                decoration: const InputDecoration(
                  labelText: 'Relator (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _decisaoController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Decisão (preencherá na ata)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _adReferendum,
                    onChanged: (value) {
                      setState(() {
                        _adReferendum = value ?? false;
                      });
                    },
                  ),
                  const Text('Ad referendum'),
                  SizedBox(width: 24),
                  Checkbox(
                    value: _fixado,
                    onChanged: (value) {
                      setState(() {
                        _fixado = value ?? false;
                      });
                    },
                  ),
                  const Text('Fixar tópico'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _adicionarPauta();
                        }
                      },
                      child: const Text('Adicionar'),
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

  Future<void> _adicionarPauta() async {

    final pauta = PautaModel(
      numero: int.parse(_numeroController.text),
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      processoSei:
        _processoSeiController.text.isEmpty
          ? null
          : _processoSeiController.text,
      solicitante:
        _solicitanteController.text.isEmpty
          ? null
          : _solicitanteController.text,
      relator: _relatorController.text.isEmpty ? null : _relatorController.text,
      decisao: _decisaoController.text.isEmpty ? null : _decisaoController.text,
      dataInclusao: DateTime.now(),
      adReferendum: _adReferendum,
      fixado: _fixado,
    );


    final pautas = [..._reuniao!.pautas, pauta];
    pautas.sort((a, b) {
      // Fixados primeiro
      if (a.fixado != b.fixado) {
        return a.fixado ? -1 : 1;
      }
      // Entre fixados, ordem de inclusão (numero)
      if (a.fixado && b.fixado) {
        return a.numero.compareTo(b.numero);
      }
      // Depois ad referendum
      if (a.adReferendum != b.adReferendum) {
        return a.adReferendum ? -1 : 1;
      }
      // Por fim, ordem de inclusão (numero)
      return a.numero.compareTo(b.numero);
    });
    final reuniaoAtualizada = _reuniao!.copyWith(pautas: pautas);

    await _atualizarReuniaoUseCase(widget.reuniaoId, reuniaoAtualizada);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pauta adicionada com sucesso')),
      );
      Modular.to.pop(true);
    }
  }
}
